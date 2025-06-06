class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.10.tar.gz"
  sha256 "9fe4f555cd3d838341443d92d18d45394d57df08aaab276bbab074ccb1a0fcb3"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbeea25cfcec8f1ef26c66e327ca30417bdc86428dcb536ea15877253960d987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e800045e39713541573a5595979e8ff443c1ab619981bcd91d3246efc245ca4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d09c10661bceee3a209c3e53735c6a70886807bc32f8b536486209a9311bc48e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf187048f8c3fe2a96d1f9b2aac78b215f270b0934366133e28c52b56f3cf8bc"
    sha256 cellar: :any_skip_relocation, ventura:       "4ef9ce6ddfacde15d4195afc6b519a600bc200ed8de31757066b08095656e2e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8906ad1adadec2a89711f401e36fef84eea31dbbdcb979024f41b786806eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3332739f15df2ace498b67e716c144b8cc7856be140d70359d1d2957e3d7f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypstyle")

    generate_completions_from_executable(bin"typstyle", "completions")
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end