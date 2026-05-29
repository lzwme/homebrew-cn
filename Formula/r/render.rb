class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "94d4e0cad8392282b1d1b2eaa15820fe933a3c0a046a343e81914c0160b0d868"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c325cf73eaef0e323216ee17d15f702423fabf18b79d20bacf6bcea51e32dd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c325cf73eaef0e323216ee17d15f702423fabf18b79d20bacf6bcea51e32dd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c325cf73eaef0e323216ee17d15f702423fabf18b79d20bacf6bcea51e32dd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ec5ed252b8b17b943cc4cf520fefbb6942354d712b1ac6aac5899674f2ddbe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f7505a9918fd204c9ff0204cc105e9f523d2ce1a30636d511ebb445d0ba49dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2739b2a7d685e176aaf8fbadf11f98d38c73d859771f04de0119c9981743514b"
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