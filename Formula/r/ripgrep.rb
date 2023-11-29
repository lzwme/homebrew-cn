class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://ghproxy.com/https://github.com/BurntSushi/ripgrep/archive/refs/tags/14.0.2.tar.gz"
  sha256 "2b9bd8a582d1fea70eb932e389e0895922b9a0147f65f9ad4b601b3f3a82a195"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7102f9ff2e2852dbed00768ea1b2a57273dde2c00775f544b697385c0fb7c533"
    sha256 cellar: :any,                 arm64_ventura:  "ca950785f8dd6d0365ba929afe87d0c360d8c3e02632f7ba4ce886cb1e91d25d"
    sha256 cellar: :any,                 arm64_monterey: "f57c46ecd8a6e35885cd13804482c00b75c389d838e8fd455a667895c425a756"
    sha256 cellar: :any,                 sonoma:         "495ebf7a9d61810b38be541c7155ea0e5c679a9ad6fb189d77f08ee1bdda032d"
    sha256 cellar: :any,                 ventura:        "015ff26fae4f1a3455631ff2e84ca5f5e209746ffcc0a488e643e3e16c6e285f"
    sha256 cellar: :any,                 monterey:       "35b9017edd694f0407059f87d6cc7aa8be787112c4ca85887ded3185b5ded195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf3faddba4b62dfa9f595d32efc03323d4e0cf67d4c6e78df4df4952923b0db3"
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