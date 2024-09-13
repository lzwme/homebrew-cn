class E2tools < Formula
  desc "Utilities to read, write, and manipulate files in ext234 filesystems"
  homepage "https:e2tools.github.io"
  url "https:github.come2toolse2toolsreleasesdownloadv0.1.0e2tools-0.1.0.tar.gz"
  sha256 "c1a06b5ae2cbddb6f04d070e889b8bebf87015b8585889999452ce9846122edf"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ec19f8ce56a63808d08a26e4b612a9ed079dd9de3278e0f23f95ad79a62c8322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "189a32d6a537cf7f38e4f935a2f6bb4f83ca9ab39140aa3e7b521f1611ed13cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11e1f3be71a478efda672fea5d23fc466c5d23d571809b459a56cb4967258fe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4764d51ea5016a50dc90a7665db17f327742011eb24d6bc3635b5e4cb7e3efda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c94d559938d504bc7ddc19139c8af004385b57db58bfd24946c451b4752928"
    sha256 cellar: :any_skip_relocation, sonoma:         "e52f7c024b90aa5c602325b326a1fab7f1a4eaea0c2f6c4eda8b1ab5c9cdddd4"
    sha256 cellar: :any_skip_relocation, ventura:        "2a0c41e09aefd7f4029d97c076a63281bbff422eeff81839e5b5a809934f3576"
    sha256 cellar: :any_skip_relocation, monterey:       "46ec372f7ee195a92d3d0f3ffca17192b48a2e9f1dd1f74b721aed99ad90cdc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "38978d9bea279b06c646bc82631d59edee4a519164f4b0a4f39b33621ae1183b"
    sha256 cellar: :any_skip_relocation, catalina:       "93eab5f2d207ac8f27a9b27db13408b4b7f8a3cfee4ecbca9d9977a851a41576"
    sha256 cellar: :any_skip_relocation, mojave:         "1ad81d83b87fc67a54698e6af829dd0945119a41a445383268f1d0190ff7b38d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "069988a622ce0587927a4a50b70b778b461840d2db2e49259e1123123bf6a2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc52ded6e99ba793baaf68c70a158ab156829f74e090b1182f9dc15d816357ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "e2fsprogs"

  # disable automake treating warnings as error,
  # upstream patch PR, https:github.come2toolse2toolspull33
  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system Formula["e2fsprogs"].opt_sbin"mkfs.ext2", "test.raw", "1024"
    assert_match "lost+found", shell_output("#{bin}e2ls test.raw")
  end
end

__END__
diff --git aconfigure.ac bconfigure.ac
index 53ad54a..89e9c52 100644
--- aconfigure.ac
+++ bconfigure.ac
@@ -11,7 +11,6 @@ AC_CONFIG_SRCDIR([e2tools.c])
 AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([
 -Wall
--Werror
 1.9.6
 foreign
 ])