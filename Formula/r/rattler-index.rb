class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.22.3.tar.gz"
  sha256 "7a39838944eb119cd78a27bd243127cdea6871908a4e22a3cc77dfc33f366cfe"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f03eda3ca790655eba98a7660465618debf093150b3053b9d4b2146d829e3825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e57fb68df0d891ae2d9a693fc0897045d4e26174975ab10e68a907d9e6e5988"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca0032351697c402bba0bb36f0e1575151314dec6397dbf4bf170a0589041c72"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e006fca9723d0bcdb60006c5c0afb9639134096d6d1936fcfb236ea2e0273f2"
    sha256 cellar: :any_skip_relocation, ventura:       "4ad1451b33d7ebf8ba1a93e2050a277183f536018c3b4b1de162963cb128c8ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42260f23fe0140a7cf0c6ff12e8dd496f7b1ae277fbb53e8c6d84414ed649805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c916d61c75794d2a3ceb6331fe4994a6fcd172728e4e83e0dd8088f5005b82"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end