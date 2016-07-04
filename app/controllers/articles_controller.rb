class ArticlesController< ApplicationController
  before_action :authenticate_user!,only: [:create,:new]
  before_action :set_article,except: [:index,:new,:create,:myArticles]
  before_action :authenticate_editor!,only: [:new,:create,:update]
  before_action :authenticate_admin!,only: [:destroy,:publish]
  #GET / Articles
  def index
    @articles = Article.paginate(page: params[:page],per_page:6).publicados.ultimos

  end
  def myArticles
      @articles = current_user.articles.paginate(page: params[:page],per_page:6).publicados.ultimos
  end
  # GET /articles/:id
  def show
    @article.update_visits_count
    @comment = Comment.new
    # #WHERE
    #   Article.where("id = ? OR title = ?",params[:id],params[:title])
  end

  def new
    @article = Article.new
    @categories=Category.all
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  def update

   if @article.update(article_params)
    @article.categories=params[:categories]
   redirect_to @article
  else
   render :edit
  end
  end
    #POST   /articles/new
    def create
       @article = current_user.articles.new(article_params)
       @article.categories=params[:categories]
      if  @article.save
        redirect_to @article
      else
        render :new
      end
    end

    def edit

    end

    def publish
     @article.publish!
     redirect_to @article
    end
  #esto define cuales atributos son posible de cambiar por el usuario,se puede controlar los datos flexibles para evitar sqlinjection
  private
  def set_article
   @article= Article.find(params[:id])
  end
  def article_params
    params.require(:article).permit(:title,:body,:cover,:categories,:markup_body)
  end
end
