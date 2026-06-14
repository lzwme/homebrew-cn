class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://ghfast.top/https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.0.1.tar.gz"
  sha256 "9a283925d85a41f483997f43213738e9b12a091bf94da20b0f94fe990903725d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f6d84fa7010ec085d364bc948445cb923beeae4ad16e858a1a31e7e0ed41bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4db436cd0ed59832f501a2640aa96f9369b5f313b8ab2ee6da4e9686ef4a74b"
  end

  depends_on xcode: ["16.4", :build]
  depends_on :macos

  uses_from_macos "swift"

  resource "XcodesKit" do
    url "https://ghfast.top/https://github.com/XcodesOrg/XcodesKit/archive/refs/tags/v1.0.3.tar.gz"
    sha256 "b8b1740467752421515cc741de2e066f104c66ac0c70fc8e7676816261c37685"
  end

  resource "XcodesLoginKit" do
    url "https://ghfast.top/https://github.com/XcodesOrg/XcodesLoginKit/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "d0e25a892b03c272a533f7e9ea7f9ea9f6bbd34c51dbfef1d0069f5787e154a6"
  end

  def install
    (buildpath/"xcodes").mkpath
    mv Dir["*"] - ["xcodes"], buildpath/"xcodes"

    resource("XcodesKit").stage(buildpath/"XcodesKit")
    resource("XcodesLoginKit").stage(buildpath/"XcodesLoginKit")

    cd "xcodes" do
      system "swift", "build", "--disable-sandbox", "--configuration", "release"
      bin.install ".build/release/xcodes"
      generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
    end
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end