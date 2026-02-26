class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "5106cf015ea099c285658ac5c94fe27804eac515d8075ff21aed1ffe642fea8e"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6651e1a7d9b6a17de29a365394561d35c36246f53f02a5a7e00a8dcefb096b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6651e1a7d9b6a17de29a365394561d35c36246f53f02a5a7e00a8dcefb096b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6651e1a7d9b6a17de29a365394561d35c36246f53f02a5a7e00a8dcefb096b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "edef855cbf03353d5f44ba614f9526b6382e12f54b36bd8606bbfc8186716e63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6dce7ffda46879d145b1e00a38159f1f02ab3a8bec9cc9929767a07af683346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a72c08f3895991335281480fa5dcedf3490f2768620f78c56fa6b41798a0b0"
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