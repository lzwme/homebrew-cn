class Jd < Formula
  desc "JSON diff and patch"
  homepage "https:github.comjosephburnettjd"
  url "https:github.comjosephburnettjdarchiverefstagsv1.9.0.tar.gz"
  sha256 "3a9ab8857f269f2c0117e7c118ce9a151d94000fab3ce800f24cae0fe8a1fbde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89b649adde7275b09e7ee30483af8b5a80e9f581fc5543e66c9010cb8e4a4822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89b649adde7275b09e7ee30483af8b5a80e9f581fc5543e66c9010cb8e4a4822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89b649adde7275b09e7ee30483af8b5a80e9f581fc5543e66c9010cb8e4a4822"
    sha256 cellar: :any_skip_relocation, sonoma:         "583cfffe9095ec88bacb9aa9119d3a332f390461f001e46bb6e7f759bad7ca1a"
    sha256 cellar: :any_skip_relocation, ventura:        "583cfffe9095ec88bacb9aa9119d3a332f390461f001e46bb6e7f759bad7ca1a"
    sha256 cellar: :any_skip_relocation, monterey:       "583cfffe9095ec88bacb9aa9119d3a332f390461f001e46bb6e7f759bad7ca1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d670d0b8b689363493d05f472237407224d7279e7ad9062e23ed6aa568fe9ba"
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
    output = shell_output("#{bin}jd a.json b.json", 1)
    assert_equal output, expected
    assert_empty shell_output("#{bin}jd b.json c.json")
  end
end