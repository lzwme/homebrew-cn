cask "recipeui" do
  arch arm: "aarch64", intel: "universal"

  version "0.8.10"
  sha256 arm:   "d2bb4e779b14fbf42f329c214527ca1c4e81ad93e6b2933de36f1b681344f858",
         intel: "f3932f4123eca54569688a58e303b91cd6a8db21debca9fdca8031cf0a7885ab"

  url "https:github.comRecipeUIRecipeUIreleasesdownloadapp-v#{version}RecipeUI_#{arch}.app.tar.gz",
      verified: "github.comRecipeUIRecipeUI"
  name "RecipeUI"
  desc "API discovery, testing and sharing tool"
  homepage "https:recipeui.com"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-06-23", because: :discontinued

  auto_updates true

  app "RecipeUI.app"

  zap trash: "~LibraryCachecom.recipeui"
end