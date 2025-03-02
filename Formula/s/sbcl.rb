class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.2/sbcl-2.5.2-source.tar.bz2"
  sha256 "5dc27eba7dda433df53fd7441de8b11474a82cdac1689c1f6ce55fa065d65fac"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0262e7cfeb987a30800866e579df10fa6268b05cb52a3051dc9f3d6ef23b6b5"
    sha256 cellar: :any,                 arm64_sonoma:  "8c94bfb6459b664a82abc7100a967a72cfb0ae81e501e0232a1df1906b61115a"
    sha256 cellar: :any,                 arm64_ventura: "be6f8aa520614c8a869446ce5cebb9637c0a755ac77eb1b565865c7f90442d5c"
    sha256 cellar: :any,                 sonoma:        "b2a1aa90ff0b97154f680bbec6fc3e473f27aa80487a2d62c9c529668fffda8a"
    sha256 cellar: :any,                 ventura:       "8124e989e0f02f477f801fd0b1b7831769f574e304149de7acc5c760287b8c19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56a082bcdeb11622190a0d13bbf1c5f7beac09ace5b78908bfe2f14f56efdacf"
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
    (lib/"sbcl/sbclrc").write <<~LISP
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    LISP
  end

  test do
    (testpath/"simple.sbcl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end