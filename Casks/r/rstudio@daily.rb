cask "rstudio@daily" do
  version "2024.07.0-daily-138"
  sha256 "be1d400c990022f6bcc5d356250dfa8027732462711f8a536422e0868bde500c"

  url "https://s3.amazonaws.com/rstudio-ide-build/electron/macos/RStudio-#{version}.dmg",
      verified: "s3.amazonaws.com/rstudio-ide-build/electron/macos/"
  name "RStudio Daily"
  desc "Data science software focusing on R and Python"
  homepage "https://dailies.rstudio.com/"

  livecheck do
    url "https://dailies.rstudio.com/rstudio/latest/index.json"
    strategy :json do |json|
      json["products"]["electron"]["platforms"]["macos"]["version"]
        &.tr("+", "-")
    end
  end

  conflicts_with cask: "rstudio"
  depends_on macos: ">= :monterey"

  app "RStudio.app"

  zap trash: "~/.rstudio-desktop"

  caveats <<~EOS
    #{token} depends on R. The R Project provides official binaries:

      brew install --cask r

    Alternatively, the Homebrew-compiled version of R omits the GUI app:

      brew install r
  EOS
end