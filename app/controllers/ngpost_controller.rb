class NgpostController < ApplicationController
  layout "angular-layout"
  before_action :set_post, only: [:show, :edit, :update, :destroy, :add_vote, :minus_vote]
  Vote_time_limit = 6
  
  def index
  end
  
  def post_list
      @items_per_page = 5
      @post_lists = Post.all.order(:id).includes(:vote_records).page(params[:page]).per(@items_per_page)
      
      @result_array = []
      @post_lists.collect do |post|
       post.can_vote_tag = can_vote_any_more?(post)
      end 
      
      render json: @post_lists , :include => :vote_records, :except => [:updated_at]
  end

  def get_ip
      @remote_ip = request.env["HTTP_X_FORWARDED_FOR"].split(",")[0] || request.remote_ip.split(",")[0] unless request.env["HTTP_X_FORWARDED_FOR"].nil?
      if @remote_ip.nil?
        @remote_ip = ""
      end
      render json: [{IP:@remote_ip}]
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
      # format.html { redirect_to root_path }
      # # if the response format is javascript, do something else...
      # format.js { }
      format.json { render json: [ switch: @switch, post_id: @post.id, goodvote: @post.goodvote, badvote: @post.badvote ]}
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
      format.json { render json: [ switch: @switch, post_id: @post.id, goodvote: @post.goodvote, badvote: @post.badvote ]}
    end
   end
 
   private
   
   # Use callbacks to share common setup or constraints between actions.
   def set_post
      @post = Post.find(params[:id].to_i)
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
    if remote_ip.nil? || remote_ip == ""
      VoteRecord.where(:uuid => "#{session[:visitor_id]}", :post_id => post.id ).count < Vote_time_limit ? true : false        
    else
      VoteRecord.where(:ip => "#{remote_ip}", :post_id => post.id ).count < Vote_time_limit ? true : false
    end      
   end

  

end
