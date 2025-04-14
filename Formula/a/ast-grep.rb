class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.36.3.tar.gz"
  sha256 "329f45e52a02991a4100ca79fcadc21c11278efd088103bae8e14d1a39c203d7"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "952552601489fdbfe6ec2fe9eda68d2e357fe016206e4d71509be1c7d871ccfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2fbb6769d5d67b08176914c3d773f121bdbfc2b378f690a4fa1baf257bcd774"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50ab4a4835988e894977c69a3e562f829b937ec08e9ecb5a7493fe0c75812f79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0c8f9beddbc199f71c29509668994ed7dda31e0abd08c84b23ee8eed4367d53"
    sha256 cellar: :any_skip_relocation, ventura:       "9c7544674f48049a786be7d3cf71cdcf42d401753f41b70a4c9b7680947e68d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7047a3627dd93be55151c2a4a1b71dd71b6dbe33f379960bc3ec0b6487ee6642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b185058f7c77916828f46408aac9b62bbf06979ec531863d345aaec6e6547c51"
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