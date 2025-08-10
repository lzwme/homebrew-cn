class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://ghfast.top/https://github.com/josephburnett/jd/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "9f5cf5c0955372b75c8877a9811e0b9ead3682603231558484f47352ee097e9c"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e23ef98402ecbb0b3fb7a3b71217fbe15d3242403e6c28c1cd55e3f4912835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48e23ef98402ecbb0b3fb7a3b71217fbe15d3242403e6c28c1cd55e3f4912835"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48e23ef98402ecbb0b3fb7a3b71217fbe15d3242403e6c28c1cd55e3f4912835"
    sha256 cellar: :any_skip_relocation, sonoma:        "8efd7c641f8d4050810ce9f6f945620be69b36cc6ef85235db0d7892f99f91b7"
    sha256 cellar: :any_skip_relocation, ventura:       "8efd7c641f8d4050810ce9f6f945620be69b36cc6ef85235db0d7892f99f91b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b27cd86044389a44d2487e46791dc8bb4d1fb0a9b9a58c5bc295a8c2f1d7eb92"
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