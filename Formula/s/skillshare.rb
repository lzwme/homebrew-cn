class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.28.tar.gz"
  sha256 "8cac0854f0cff8207af788b13f9a5fb69b8d93230c7b2d29ca8c1080d5807369"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12f8e6db8ca5f8d667aadcb56d8be148b8406ffb5f6587f2fb132def7e605227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f8e6db8ca5f8d667aadcb56d8be148b8406ffb5f6587f2fb132def7e605227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f8e6db8ca5f8d667aadcb56d8be148b8406ffb5f6587f2fb132def7e605227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48bb7e9af55dc9b9d4d2dec227ef3dac190c95364f565a8c280bd7c789982c86"
    sha256 cellar: :any,                 x86_64_linux:  "7e58c99175c13146dc82e81d50aecf704f719fd45b97b49937106248731b20f9"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end