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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "dbd82dd08d29dcf108b351483cb92609efa78a4159aa27c3dd6a457f9886849e"
    sha256 cellar: :any,                 arm64_ventura:  "75ef47553c46033dda0cb96f878bc5bd6b78494440c780441ce116d14277a720"
    sha256 cellar: :any,                 arm64_monterey: "4abbf9b3a18a4e4da789398511dfb121952c2910a0fdfb35ec048f6b77038361"
    sha256 cellar: :any,                 sonoma:         "f76b0fcad39cfa9af05c9a0e6a2e8dd9be4511e0359893c027da10b09b35544e"
    sha256 cellar: :any,                 ventura:        "9bf63d219c64f5245992eb5e1d3723ca61674d144a6487f270a9d5bacfe46e69"
    sha256 cellar: :any,                 monterey:       "e99c9246324a1dece4447643a2edc62d97509158e1433fa3a01bc579303d1bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "470a87429d5c7e39e1422e6098c4a201855b01b362f454f5a52debb101e146a7"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", "--features", "pcre2", *std_cargo_args

    generate_completions_from_executable(bin/"rg", "--generate", base_name: "rg", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end