cask "font-inconsolata-lgc" do
  version "1.13.1"
  sha256 "86c3ce88e3e8c35a01f824b46bf3eae8d9d8bddcb54ed5b648b9b64f4cd6b445"

  url "https:github.comMihailJPInconsolata-LGCreleasesdownloadLGC-#{version}InconsolataLGC-#{version}.tar.xz"
  name "Inconsolata LGC"
  homepage "https:github.comMihailJPInconsolata-LGC"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "InconsolataLGCInconsolata-LGC.ttf"
  font "InconsolataLGCInconsolata-LGC-Bold.ttf"
  font "InconsolataLGCInconsolata-LGC-Italic.ttf"
  font "InconsolataLGCInconsolata-LGC-BoldItalic.ttf"

  # No zap stanza required
end