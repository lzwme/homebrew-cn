class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "ef625322a8e7d9cdc0fd4411deda38b640eccafa991a019103658a1e1ba7704e"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aacfe55db85d0c5ea6b13dbd945cbd587af8e7bb2457621b88dd71e95d3442e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aacfe55db85d0c5ea6b13dbd945cbd587af8e7bb2457621b88dd71e95d3442e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aacfe55db85d0c5ea6b13dbd945cbd587af8e7bb2457621b88dd71e95d3442e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e1ab6ac9a35f63ab062509ffb4c7092214aa5fe16a9ba906167746f786beb2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c335bf633ffc0b7b335ad24f92f2f61c37bb473795cd9a693d8e8980c4fb8ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "236d310ef391625e228288ddade5561034aa6b25d03cbb4270151e293e079ac9"
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