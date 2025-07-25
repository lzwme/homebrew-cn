class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://ghfast.top/https://github.com/josephburnett/jd/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "eb15f4eef5d418ef002c388f1c30b5802cea3f30609185ce4d12ef05e5148711"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da935978b2656b746d702e3fb024c6e317708eab643319fe0dcb18f59445972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3da935978b2656b746d702e3fb024c6e317708eab643319fe0dcb18f59445972"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3da935978b2656b746d702e3fb024c6e317708eab643319fe0dcb18f59445972"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a8155352942e2e58c176d2f90027a98d2d995e7b185303a8dfb52f6b0e4da26"
    sha256 cellar: :any_skip_relocation, ventura:       "4a8155352942e2e58c176d2f90027a98d2d995e7b185303a8dfb52f6b0e4da26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9536cec9c0feddf8147504272ce24a723402521666271e28161508fe44ec8db9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./v2/jd/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jd --version")

    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}/jd a.json b.json", 1)
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end