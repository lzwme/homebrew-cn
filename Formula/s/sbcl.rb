class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.0/sbcl-2.6.0-source.tar.bz2"
  sha256 "0a4bd5b01c88e6b45c2f059605d2728ab9377a6529b2ea622a7abb5ba2d691c6"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f8c81861fd926ac9b9681e0467528bc1711e4896a7f715756aebc29f18d7efc"
    sha256 cellar: :any,                 arm64_sequoia: "44011cf2048983a1d01e61c9174fbf4b97f710c595ea02b0c1619260e65c9199"
    sha256 cellar: :any,                 arm64_sonoma:  "ad14d1e14877d2a1782863df901207113fe15cb015d0a2a85a484ad60ea9ac3e"
    sha256 cellar: :any,                 sonoma:        "e15de84a061cc2d1cfead72918386fad16647ecdfb633a6edb380502f001a24e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f27370019faf12b2f93fe6c3c5c45e8ae663db07bbabd23fbd8b635dac6f4474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ef4ec4ece834b4d927cfda13234107e36437f98a533991f71ebe884620f620"
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