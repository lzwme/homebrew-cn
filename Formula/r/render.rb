class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "c4907e10d33bda47aa38f1629765298055540be771d67962055a4fa278d35dbb"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9702a6ab329b6081c140ba5c77694a1d17c7ecff8fbb383d295078ba34a95b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9702a6ab329b6081c140ba5c77694a1d17c7ecff8fbb383d295078ba34a95b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9702a6ab329b6081c140ba5c77694a1d17c7ecff8fbb383d295078ba34a95b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd16421af1575a4d48427ce4d4819e54844dfa14e0a8ad470ef3a12639858af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84e654a0e184463edcd1fe3a1e29976a6910a6930856184f943bd072fd0e9661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6f37d03bba8e84079cefcb61d6bfbcf7308fe8c2a2c1fd9248038a41f48c02"
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