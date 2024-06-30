class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https:vanheusden.commultitail"
  url "https:github.comfolkertvanheusdenmultitailarchiverefstags7.1.3.tar.gz"
  sha256 "f55732781f7319e137a3ff642a347af1aaf3ed5265ed12526bdd0666d708d805"
  license "MIT"
  head "https:github.comfolkertvanheusdenmultitail.git"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "85f9d755e256e34e0aa8124e3b72204cdd8626f6a0049f9613bbd0f09f235c6a"
    sha256 cellar: :any,                 arm64_ventura:  "c8a2a1107b2961ab2a29e7330b853e9cffd5fc7899fa77936fc38799e9a7547a"
    sha256 cellar: :any,                 arm64_monterey: "1e1707743b8af156281668a90f0d4ad911a8d9933b6c420a78096d5974b9ed3a"
    sha256 cellar: :any,                 sonoma:         "a1473bc82165fd249e0c6097538019e7c0afe9a6be51b734a293c605395e47fd"
    sha256 cellar: :any,                 ventura:        "c08f64a95cb7a30f521822d5a39be9ce14a991130c357a90155a9aef49ca0ad8"
    sha256 cellar: :any,                 monterey:       "5378cb6701af8853f0d5004f9f9b614311f9920b191391c4782c2fbc7c3503b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb0e34602486174a324495b68e4770466bb79a109ff22fa9f633a5cf825d03bd"
  end

  depends_on "pkg-config" => :build
  depends_on "ncurses"

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install Utils::Gzip.compress("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}multitail -h 2>&1", 1)
    end
  end
end