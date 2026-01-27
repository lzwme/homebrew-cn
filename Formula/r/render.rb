class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "2617d88b23ae0babfce8be57af6762341a2fac57a8503cc84b04bacc69209b1e"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78e9ac0bba1e6dd12073a7061f40273d9fa9aab92f3ea51ed1eaf01594b276ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78e9ac0bba1e6dd12073a7061f40273d9fa9aab92f3ea51ed1eaf01594b276ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78e9ac0bba1e6dd12073a7061f40273d9fa9aab92f3ea51ed1eaf01594b276ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d885bf987438ec11ea4918c745bff9601abcfd37de353317664157fbb0e122b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ca0c8d2bd24316e6aaa8c09f2b44dd8003c1c5f036188222f2e841cdff869a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086d76755a7bca646142d35b8d4598f32f6dda40d1347b69dce8d6d4e3f3b265"
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