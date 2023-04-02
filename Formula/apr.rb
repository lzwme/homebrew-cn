class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  # TODO: Remove `libexec` symlinks in `install` when we no longer have a Big Sur bottle.
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.3.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.3.tar.bz2"
  sha256 "455e218c060c474f2c834816873f6ed69c0cf0e4cfee54282cc93e8e989ee59e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3697f4c0227f5ffbe41d20c423c4ef730f32aafa70b52865704cd8a1e1220c26"
    sha256 cellar: :any,                 arm64_monterey: "d9f601cdda4fa5b62ed76c9a7041c822812b9e595ec7d0855fe404e3c7941eae"
    sha256 cellar: :any,                 arm64_big_sur:  "935eda60609ca25d2a50ad861ba6e1ea52c665c9df448a7f861bac4eefdef0e0"
    sha256 cellar: :any,                 ventura:        "7792ae2d5c7c02256067b1b8ba2e4ad285c4073171d490cd6e9f86b286533981"
    sha256 cellar: :any,                 monterey:       "65f233596129807c1f3a33701b75d62e988f62e02c0d3f4f8696aedb582f4d64"
    sha256 cellar: :any,                 big_sur:        "58fc4394bb261149b6164e83ce616895e40105bb1906268584098ee8039141e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5450c46b42ad402b89ceab9d0c0e7d49b923e11fac981950fbeabe7ea93330d6"
  end

  keg_only :provided_by_macos, "Apple's CLT provides apr"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "util-linux"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    system "./configure", *std_configure_args
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # Remove when we no longer have a Big Sur bottle.
    (libexec/"lib").install_symlink lib.glob(shared_library("*"))

    rm lib.glob("*.{la,exp}")

    # No need for this to point to the versioned path.
    inreplace bin/"apr-#{version.major}-config", prefix, opt_prefix

    # Avoid references to the Homebrew shims directory
    inreplace prefix/"build-#{version.major}/libtool", Superenv.shims_path, "/usr/bin" if OS.linux?
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apr-#{version.major}-config --prefix")
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <apr-#{version.major}/apr_version.h>
      int main() {
        printf("%s", apr_version_string());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lapr-#{version.major}", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end