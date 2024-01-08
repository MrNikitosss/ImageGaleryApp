
final class SceneFactory {

    static func produceTabBarController() -> TabBarContainerView {
        let stb = StoryboardScene.TabBarContainerView.storyboard
        let vc = stb.instantiateViewController(withIdentifier: StoryboardScene.TabBarContainerView.storyboardName) as! TabBarContainerView

        return vc
    }

    static func produceImagesListController() -> ImagesListView {
        let stb = StoryboardScene.ImagesListView.storyboard
        let vc = stb.instantiateViewController(withIdentifier: StoryboardScene.ImagesListView.storyboardName) as! ImagesListView

        return vc
    }

    static func produceFavoritesImagesController() -> FavoritesPhotosView {
        let stb = StoryboardScene.FavoritesPhotosView.storyboard
        let vc = stb.instantiateViewController(withIdentifier: StoryboardScene.FavoritesPhotosView.storyboardName) as! FavoritesPhotosView

        return vc
    }

    static func produceImageDescriptionController() -> ImageDescriptionView {
        let stb = StoryboardScene.ImageDescriptionView.storyboard
        let vc = stb.instantiateViewController(withIdentifier: StoryboardScene.ImageDescriptionView.storyboardName) as! ImageDescriptionView

        return vc
    }
}
