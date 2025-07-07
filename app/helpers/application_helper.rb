module ApplicationHelper
  def default_meta_tags(url: "https://res.cloudinary.com/dbar0jd0k/image/upload/v1751849504/conference_survival_gk6xcw.png")
    {
      site: "会議サバイバル診断",
      title: "会議サバイバル診断",
      reverse: true,
      charset: "utf-8",
      description: "長時間会議を生き抜くあなたの“会議サバイバルスキル”を診断します。",
      canonical: request.original_url,
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: url,
        locale: "ja-JP"
      },
        twitter: {
        card: "summary_large_image",
        image: url
      }
    }
  end
end
