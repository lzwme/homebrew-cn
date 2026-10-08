class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://oath-toolkit.codeberg.page/"
  url "https://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-2.6.14.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.14.tar.gz"
  sha256 "8b1da365759f1249be57a82aec6e107f7b57dc77d813f96dc0aaf81624f28971"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 4

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4e662f9f30e5e1bee799d16dcac327e818d2531b575bd8f3ab267384f441d255"
    sha256 cellar: :any, arm64_tahoe:       "bc7a42c98485476e9702bace709a61aa37ca54e1dd89fdafa11b3a5d6c19348e"
    sha256 cellar: :any, arm64_sequoia:     "b45a1920453e7471b7320cebc49460ccf1280e19992ddb5e078a802a5ebf13eb"
    sha256               arm64_linux:       "d9eb606c76e2baa82340f446aafd7cefed6f733c00130222f1f912c4c5a9f892"
    sha256               x86_64_linux:      "da319675b26f90952f7a0a66fd2cc953529302cbd715a7579e5056e014f37e33"
  end

  head do
    url "https://codeberg.org/oath-toolkit/oath-toolkit.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkgconf" => :build

  depends_on "libxml2"
  depends_on "libxmlsec1"

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end