# Posts Controller
class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order('updated_at DESC')
    @tags = Tag.order('posts_count DESC')
  end

  def filter
    @posts = Tag.friendly.find(params[:tag_name]).posts
    @tags = Tag.order('posts_count DESC')
    render :index
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.tags.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    if @post.save
      flash[:success] = 'Post was successfully created.'
      redirect_to posts_path
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      flash[:success] = 'Post was successfully updated.'
      redirect_to posts_path
    else
      render :edit
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    flash[:success] = 'Post was successfully destroyed.'
    redirect_to posts_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
    @post.tags_string = @post.tags.map(&:name).join(', ')
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def post_params
    params.require(:post).permit(:author, :title, :body, :tags_string)
  end
end
