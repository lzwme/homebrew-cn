class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "e4598de538d4214d0d500ab347cd3c15f5c6bbe3c1b5732236075b60ff8439fb"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfae0db9e7228d0d7073880fffe74091dd46cf44bf623c3767fe4749bb3ef1dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfae0db9e7228d0d7073880fffe74091dd46cf44bf623c3767fe4749bb3ef1dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfae0db9e7228d0d7073880fffe74091dd46cf44bf623c3767fe4749bb3ef1dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d463a067fee45d0382b599a96f4185d6576867aa6d07b8568b453a47c7c2d8da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c6f6fdccb84629b60586347af6980010bb88f25a4f4c89792a9d027da7fe15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63696e56954005278fb95a946d930f1619e75dd40747ae84e4aea197caad6d05"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end