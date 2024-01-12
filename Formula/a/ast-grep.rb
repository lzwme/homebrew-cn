class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.17.0.tar.gz"
  sha256 "ffc432546e1e8c3bb7d0143c35e765f6562e0c2979ec723f7abf50748d0a4559"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d93cdc1736a42f1d878d6d86fabd62674614416290acab016e22927782310aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc5539344ec0ee740e75d4108bf1fc2a58007c6c7c094d0d83a804d64f44077e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876d3669287775bdbe370b755bdf9bc8350fd9edc6d84eb6c714b5246f13249d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f09a98c49f57f1b52de31a43337e09f46e9b091c5cf61d8e8f0d0b371630b711"
    sha256 cellar: :any_skip_relocation, ventura:        "7e4d4343d67c697826e80f99f5d64f580812fe940eed0647363058a4b4535bc5"
    sha256 cellar: :any_skip_relocation, monterey:       "2c2d054b33ef198423d0ce233b7a1dc6c873059262267fe287b25451b1ae30a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5568f487549f6bf11b32bec91c5a95381e01ecfa8fce834c8504a5e6b108ebd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"sg", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end