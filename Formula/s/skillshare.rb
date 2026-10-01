class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "88ce7ce3c5a7bd41dc6a6cd9a273ce7c22058224bd90dd839f8a9e5e16fd2211"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d38a0d9f7411ca49519473a5d0c294af5f252febfd1ad1a0fd1b146bb07617e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d38a0d9f7411ca49519473a5d0c294af5f252febfd1ad1a0fd1b146bb07617e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d38a0d9f7411ca49519473a5d0c294af5f252febfd1ad1a0fd1b146bb07617e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80139fdba163981e5f56b3550307718104a54ee315cd3cf593c91de7f665e2d0"
    sha256 cellar: :any,                 x86_64_linux:      "a0986d943d0d1f1237285506be5d7529085c011fd5bde24df5895c8ef0576d05"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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