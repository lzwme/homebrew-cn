class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.8.tar.gz"
  sha256 "614b8274873aa60b7f2a80daac55dfc983abf766a9e44cb3c60ddc52812b46f8"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01f06c56f55838721f0cf5f6f6191e355d6bd65a7a3f0bdaa9c6e2c5d8f050c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d01f06c56f55838721f0cf5f6f6191e355d6bd65a7a3f0bdaa9c6e2c5d8f050c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d01f06c56f55838721f0cf5f6f6191e355d6bd65a7a3f0bdaa9c6e2c5d8f050c"
    sha256 cellar: :any_skip_relocation, sonoma:        "38fd58f2e5731fcb22e798a027e2a8db5a5bd20f2a8516c10dd2a1d6f82d6cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "038aac449c4dc07a89722cb69f5aec3a1cf2a97e36faf192005941ede3c25276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ea42229ba3313cb1500ba2e9f360141f60b5b4f36eea339203bf2638bca3f6"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end