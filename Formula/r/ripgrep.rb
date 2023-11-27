class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://ghproxy.com/https://github.com/BurntSushi/ripgrep/archive/refs/tags/14.0.1.tar.gz"
  sha256 "845cbf47729809fe82fd1f938f7880a29c1cd5c71d83e0feb9429552e0568bf6"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a3179dc65738b5f3f905ed307a4d3a79c3af584f521af501f6604dcc5a8aeb4"
    sha256 cellar: :any,                 arm64_ventura:  "f4bb082d2a8914c2454693f72f836d6c5326fe69f62d98451bf110eebe507d50"
    sha256 cellar: :any,                 arm64_monterey: "c0636cc02aa9f0128bc1d7aac588a80bef2ed1b3c2681b8bbff8d7346a89b42f"
    sha256 cellar: :any,                 sonoma:         "4695f24307c82f15a02bf172dad07c0af8421ce813f3ed67cbee5fa0ddaeab5d"
    sha256 cellar: :any,                 ventura:        "a6c2bf7a45d58b2fc15dbc02d9f23da944ad066c94ccdb721434e903e4c433b3"
    sha256 cellar: :any,                 monterey:       "bfd8bcff015c770fd2b71cd3ad34c2fedb90c23ba90e02d4fed73793bfe88298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f83f393d74ee90aa9a6219d59ca39d72014d83489499e2d09468f01d0e9344"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", "--features", "pcre2", *std_cargo_args

    generate_completions_from_executable(bin/"rg", "--generate", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end