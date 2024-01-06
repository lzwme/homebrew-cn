class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https:github.comast-grepast-grep"
  url "https:github.comast-grepast-greparchiverefstags0.16.1.tar.gz"
  sha256 "37597c75f0fa3e292b74e7040a12d58faaaa0a7c8d96c182802084b3fef56ca1"
  license "MIT"
  head "https:github.comast-grepast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c7cd7311ea667324b20fa2e2a8b31aaec8b986607dc3013b0821629d3fad390"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fa0788ecb118c0474d1203b39ca4cf902a2c4f7b27e5d79f949028ebd3b8c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e629bbbe2551fe13b11c3c8204e9429170fb1d98134f0602d86387f1955486d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b405365be2bb3d05f615479b064dac98ac7a0528589df62311dcdd05cdab1047"
    sha256 cellar: :any_skip_relocation, ventura:        "ca4b8c90fc611395fad2d44c2610a57535aec7606dda0eeb9b4a38f6c71716e7"
    sha256 cellar: :any_skip_relocation, monterey:       "e46a8300e428a77e245a5aa0d216f8f0d3a3d44a2e2113fd61558dc484e988dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f31b65ed52debf208cfcccc7750bf474746e4304a7453c2c18e955f5e6f538"
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