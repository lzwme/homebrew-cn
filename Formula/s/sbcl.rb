class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.10/sbcl-2.4.10-source.tar.bz2"
  sha256 "ceeb396b69d2913eee04841c2af6beca5c342ce1464c3fe3e453f2de10c5e2f8"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da0c659136582f7bcea4fac58afe9fc38efb7412555c7883d76ca160c025c6a9"
    sha256 cellar: :any,                 arm64_sonoma:  "a8da2ba2e2f45a0ab7aad2a41df335e4cb23724b421196c1fd60826a44336c21"
    sha256 cellar: :any,                 arm64_ventura: "7a418524dbbff6efc133c6af11c122e2a6123f06d9643033a953f1235a7cd2ce"
    sha256 cellar: :any,                 sonoma:        "c43afb20a2bf776d624260faac2a1aef44cdfe4c302af734873f3204331d00a9"
    sha256 cellar: :any,                 ventura:       "11167bc009bfcd4fe7bafc4e4ca2e385cff40262bbf7783d7e2f946f6a2b3aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a839d45656cb4b65322fea7cb02994954bc0e7d45d28c0c63d699c22210854"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end