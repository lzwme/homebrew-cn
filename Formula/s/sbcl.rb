class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.5/sbcl-2.6.5-source.tar.bz2"
  sha256 "91ec75f647252ed6e6aeae9b1a13f47c7c6cfd9b68488dc69f1a6fea5accb440"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 4
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6438b0ff5f4264bd10ffbfda00dc04b98152a021a91b76df05eb4ed49d114dc"
    sha256 cellar: :any, arm64_sequoia: "66e2d15622f353c172c03ba051eb664eebabb26870d2806ca34efd469a5f110f"
    sha256 cellar: :any, arm64_linux:   "0b608df7127b6ff44f80f962cdde2e8c73f6ea1ff6a96508898fe3ae18daf3d8"
    sha256 cellar: :any, x86_64_linux:  "a7509542c1ea7cd79c935e1463077b2ddfcc91e67e4a0fb7e5a24eda8f8ec7d9"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  # `ecl` does not support older versions
  on_macos do
    depends_on macos: :sequoia
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