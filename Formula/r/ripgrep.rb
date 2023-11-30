class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://ghproxy.com/https://github.com/BurntSushi/ripgrep/archive/refs/tags/14.0.3.tar.gz"
  sha256 "f5794364ddfda1e0411ab6cad6dd63abe3a6b421d658d9fee017540ea4c31a0e"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4993cd71e43d30dd2a664c11d662cfcb0d4a6eebba2f9569369b285e3b33a10f"
    sha256 cellar: :any,                 arm64_ventura:  "19945856a69414ea653b53501f026fec4dcdad0ee315c8a296f9c8146593793b"
    sha256 cellar: :any,                 arm64_monterey: "fde873893c65d85ac0b28eaad540f4b50a319f608d8c0e7b7bcc00e884bfb46a"
    sha256 cellar: :any,                 sonoma:         "4254cdbb026bae26c4cada5459747ae2ca6af8df9f0b98350bf3a4e904015052"
    sha256 cellar: :any,                 ventura:        "4d460d70b632a24502f826451776fbd9ee756a770e26c6911fc7853f7ec92421"
    sha256 cellar: :any,                 monterey:       "fd21355a9f00657fd1d0aaf4676220845f0ee60fbd5641cda8fee429eab8893f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f23f2842916cbcd5b1fc909e59fafee39439e5253f9295d1b7aec5b4953b0c"
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