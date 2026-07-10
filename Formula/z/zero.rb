class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://ghfast.top/https://github.com/Gitlawb/zero/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c2e1b150f5deb7eade87171a9aea944769e577bc6f88bbb80ee05c76e74f278c"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ac116192a0ada0bc2a01d89b2cb21c1493255f2c5d483733a908867178ee06b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ac116192a0ada0bc2a01d89b2cb21c1493255f2c5d483733a908867178ee06b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac116192a0ada0bc2a01d89b2cb21c1493255f2c5d483733a908867178ee06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "90b417e08efb6c9d758b6d36f77ea1547a1a4fdc4f109f76245461b8c73a5130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc299770d1f4edc42a7f389b74d810c35e9315b94da3754a186ddc23760926b6"
    sha256 cellar: :any,                 x86_64_linux:  "ca91316ce8360acbd6d428fdfc2ddbb341a8159e5d060fb28dae7b50e246e491"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Gitlawb/zero/internal/cli.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zero"
  end

  test do
    (testpath/"cmd").mkpath
    (testpath/"cmd/main.go").write <<~GO
      package main

      func main() {}
    GO

    assert_match version.to_s, shell_output("#{bin}/zero --version")

    output = shell_output("#{bin}/zero repo-map --max-files 3 --max-depth 2")
    assert_match "Repo map", output
    assert_match "cmd/main.go", output
  end
end