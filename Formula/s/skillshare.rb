class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.17.tar.gz"
  sha256 "555a5dee980ddf58fb0a50026cb82293b48203a8df7c5d3791f655ae8e4a0ba0"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a78083a7466a4865c5d7b434a7cb027444afa430a4f404b6d1aeaa3ad9f257a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a78083a7466a4865c5d7b434a7cb027444afa430a4f404b6d1aeaa3ad9f257a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a78083a7466a4865c5d7b434a7cb027444afa430a4f404b6d1aeaa3ad9f257a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e019a27aab2774c26c2aa52d71cda88f22e34e0ea94d07fce87f02c40b80ed07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eb60004afa09c9013b937282029ef5f2fdd83903d3de35e21f815fc8f2762c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635ff15afe2b763acfd0386000c3656bb46baeb39508e82e7e0e08a52b39b336"
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