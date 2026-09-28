class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.9/sbcl-2.6.9-source.tar.bz2"
  sha256 "c6fd1d735570eb4ff34caf9609988ca77ed0bd12b55d09a4fed075be890da513"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 8
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "62c404a86f264d56bd106ea5b81c9cedf86c28ad6f1b201f211217b511511136"
    sha256 cellar: :any, arm64_tahoe:       "bf1fbd12c145773884bd4eb4e106529c6ff70bd9f06b4fde64d845f732a750f3"
    sha256 cellar: :any, arm64_sequoia:     "f5ea0e39f978a60a22bf2583927e150164c7ac3142f906198fe03407280ecd87"
    sha256 cellar: :any, arm64_linux:       "3410c8fd521d0d7c6506a07a3de080958af04720e0acdf0fdbb6ed7273384d64"
    sha256 cellar: :any, x86_64_linux:      "890a44c77132873f2bbde23854100f08e7c38dde89b4347eb70c93c4f7621f4d"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  # Stop passing raw SAPs through the arm64 fixed-args convention, which miscompiles
  # UTF-8 c-string reads and hangs multi-process dependents (e.g. acl2, fricas).
  patch do
    file "Patches/sbcl/revert-utf8-c-string-simd-regression.patch"
    type :unofficial
  end

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