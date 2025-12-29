class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://ghfast.top/https://github.com/josephburnett/jd/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "914d6f131d6223b2805a33f6c39ceba647a2dd06e4cc3cf0eba8c20b9199bf63"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb83f5245139424bd69136276726976eeb7ffa18268683ca6a956b2d0bacd0a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb83f5245139424bd69136276726976eeb7ffa18268683ca6a956b2d0bacd0a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb83f5245139424bd69136276726976eeb7ffa18268683ca6a956b2d0bacd0a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "875bf4b51937e9416e8852543f7e7a8f9019cc4c6388ec5e346e3bf05c0abad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db962df5ccd0873bbd9863700480b4ad59c7cca28ed85c6eea5b402a6fd4abb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55397dc8e9b8f767b48999d42442f0f3ea3c92a5bdd55c71538fac0b9b78333f"
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