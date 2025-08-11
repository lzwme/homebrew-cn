class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://ghfast.top/https://github.com/josephburnett/jd/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "10c5ec1a3a5c67af59bde544bc8e7ae49f35355763be79e141f4e8f9f2ce524e"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39e449b63f3b5f0b288fdaaac1406e25ac922c1e8bff6ca68e65245a3afe7ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e449b63f3b5f0b288fdaaac1406e25ac922c1e8bff6ca68e65245a3afe7ae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39e449b63f3b5f0b288fdaaac1406e25ac922c1e8bff6ca68e65245a3afe7ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "05258c25b7b7c1b5652d808a8510d37797797d177d39c2aad2117c3495e8b493"
    sha256 cellar: :any_skip_relocation, ventura:       "05258c25b7b7c1b5652d808a8510d37797797d177d39c2aad2117c3495e8b493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa69c9036be51f6ca72b074da190c816dafcf77d6fcb1d34a50a62d62171510"
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