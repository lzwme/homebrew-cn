class Jd < Formula
  desc "JSON diff and patch"
  homepage "https:github.comjosephburnettjd"
  url "https:github.comjosephburnettjdarchiverefstagsv2.2.1.tar.gz"
  sha256 "d9e2378c07be60ba42eb1a87e5b5c9eac9f0078b3643757a8d560e2690327c36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2f733ce207542edd59c40aa491ca0428dbf8a87e26efab92e02b1de5c33eba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c2f733ce207542edd59c40aa491ca0428dbf8a87e26efab92e02b1de5c33eba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c2f733ce207542edd59c40aa491ca0428dbf8a87e26efab92e02b1de5c33eba"
    sha256 cellar: :any_skip_relocation, sonoma:        "664bdb927272679f79242a2d1a76dd64796ed4a06613132b6963beb3803e8c07"
    sha256 cellar: :any_skip_relocation, ventura:       "664bdb927272679f79242a2d1a76dd64796ed4a06613132b6963beb3803e8c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1d7b9136602c89c5bfb82419dfbe34dd434ceba4fa92fc7ef7ce60a7518db1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"a.json").write('{"foo":"bar"}')
    (testpath"b.json").write('{"foo":"baz"}')
    (testpath"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}jd a.json b.json", 1)
    assert_empty shell_output("#{bin}jd b.json c.json")
  end
end