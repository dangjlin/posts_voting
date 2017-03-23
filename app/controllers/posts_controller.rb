class PostsController < ApplicationController
   before_action :set_post, only: [:show, :edit, :update, :destroy, :add_vote, :minus_vote]
   Vote_time_limit = 3
   helper_method :can_vote_any_more?
   # GET /posts
   # GET /posts.json
   def index
      @items_per_page = 5
      @posts = Post.all.order(:id).includes(:vote_records).page(params[:page]).per(@items_per_page)
      @record = Post.new
      #if env["HTTP_X_FORWARDED_FOR"] = nil?
      @remote_ip = request.env["HTTP_X_FORWARDED_FOR"].split(",")[0] || request.remote_ip.split(",")[0] unless request.env["HTTP_X_FORWARDED_FOR"].nil?
      @user = VoteRecord.find_by(:ip => "#{@remote_ip}")
      if @user.nil? 
      session[:visitor_id] ||= SecureRandom.uuid
      else
      session[:visitor_id] = @user.uuid
      end
      @uuid = session[:visitor_id]
      @limit = Vote_time_limit
      @check_list = VoteRecord.group(:post_id).where(:ip => "#{@remote_ip}").count

   end
   
   # GET /posts/1
   # GET /posts/1.json
   def show
   end
   
   # GET /posts/new
   def new
      @post = Post.new
   end
   
   # GET /posts/1/edit
   def edit
   end
   
   # POST /posts
   # POST /posts.json
   def create
      @post = Post.new(post_params)
      
      respond_to do |format|
         if @post.save
            format.html { redirect_to @post, notice: 'Post was successfully created.' }
            format.json { render :show, status: :created, location: @post }
         else
            format.html { render :new }
            format.json { render json: @post.errors, status: :unprocessable_entity }
         end
      end
      
   end
   
   # PATCH/PUT /posts/1
   # PATCH/PUT /posts/1.json
   def update
      respond_to do |format|
         if @post.update(post_params)
            format.html { redirect_to @post, notice: 'Post was successfully updated.' }
            format.json { render :show, status: :ok, location: @post }
         else
            format.html { render :edit }
            format.json { render json: @post.errors, status: :unprocessable_entity }
         end
      end
      
   end
   
   # DELETE /posts/1
   # DELETE /posts/1.json
   def destroy
      @post.destroy
         respond_to do |format|
         format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
         format.json { head :no_content }
      end
   end

   def add_vote
    @switch = can_vote_any_more?(@post)
    if @switch
    @post.goodvote += 1 
    @post.save
    record_vote_data(@post, 1)
    end
    respond_to do |format|
      # if the response fomat is html, redirect as usual
      format.html { redirect_to root_path }
      # if the response format is javascript, do something else...
      format.js { }
    end
    
   end

   def minus_vote
    # 如果總分不允許負分出現的話，這邊要再多判斷  badvote 分數是不是已經大於 goodvote 分數
    @switch = can_vote_any_more?(@post)
    if @switch 
      @post.badvote += 1 
      @post.save
      record_vote_data(@post, -1)   
    end    
    respond_to do |format|
      # if the response fomat is html, redirect as usual
      format.html { redirect_to root_path }
      # if the response format is javascript, do something else...
      format.js { }
    end
   end
 
   private
   
   # Use callbacks to share common setup or constraints between actions.
   def set_post
      @post = Post.find(params[:id])
      @limit = Vote_time_limit
   end
   
   # Never trust parameters from the scary internet, only allow the white list through.
   def post_params
      params.require(:post).permit(:title, :content)
   end

   def record_vote_data(post , idea)
    @vote_record = post.vote_records.build
    @vote_record.uuid = session[:visitor_id]
    @vote_record.ip = request.env["HTTP_X_FORWARDED_FOR"].split(",")[0] unless request.env["HTTP_X_FORWARDED_FOR"].nil?
    @vote_record.idea = idea 
    @vote_record.name = (@vote_record.ip.nil?) ? "訪客 " : "訪客 " + @vote_record.ip
    @vote_record.save       
   end

   def can_vote_any_more?(post)
    remote_ip = request.env["HTTP_X_FORWARDED_FOR"].split(",")[0] unless request.env["HTTP_X_FORWARDED_FOR"].nil?
    if remote_ip = ""
      VoteRecord.where(:uuid => "#{session[:visitor_id]}", :post_id => post.id ).count < Vote_time_limit ? true : false        
    else
      VoteRecord.where(:ip => "#{remote_ip}", :post_id => post.id ).count < Vote_time_limit ? true : false
    end      
   end


end
