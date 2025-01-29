class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.34.3.tar.gz"
  sha256 "92a462b757703bcae26e0cb4e5f2485b3651e043bedbd73eda68c15c54602111"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "680e4ed3c8544f950dd9e711090cec7503557419c74f48176ea156a0bdbdc47e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca38108eedc2bd473bbcb9eef02181e7e89f2585e95e1b9b146f4e618b7c4b80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da29fcbdb82c23dec6843fde54893173aeb147aa1fa6e29fc916d223bb7e8af5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6545b28e7f300ff7812cf2bb5b3cdf538b3d4bff42471f67a4845948a1de5b58"
    sha256 cellar: :any_skip_relocation, ventura:       "3d43e6da171440cc1e61fda445e9a6c7ea71963b7a83af9bfb04cd94dc30110d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b89bc69e0f7b34338eab3405eb5a219296be5315bbae3df3b1297bb30390bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")

    generate_completions_from_executable(bin"ast-grep", "completions")
  end

  test do
    (testpath"hi.js").write("console.log('it is me')")
    system bin"ast-grep", "run", "-l", "js", "-p console.log", (testpath"hi.js")

    assert_match version.to_s, shell_output("#{bin}ast-grep --version")
  end
end