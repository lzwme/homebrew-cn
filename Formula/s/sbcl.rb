class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.6/sbcl-2.4.6-source.tar.bz2"
  sha256 "a489907842dae09a1726d62985bf7a56670aaea2f3eca1fb7023bca67c3f3091"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3254f78e86f7e09ee213fb91be7cd83ad304f977f9d8ce3c67f9171a510d4816"
    sha256 cellar: :any,                 arm64_ventura:  "13a2b67aa22928dae431dc5394619b11b1a8eb0998b8d53e31018a1ef8196c9c"
    sha256 cellar: :any,                 arm64_monterey: "d357a9189fdcd55121da84a29eb3cc5b9336f6a9f8dbfec03dee7276724de559"
    sha256 cellar: :any,                 sonoma:         "0bb55eb0a9fe2e09141f078d720032d79c372b1cbd32ab5a956aaf0579987c2c"
    sha256 cellar: :any,                 ventura:        "70c233cd5044316108176cfaa0e1215490cb874195acb0b25c6b42e654794181"
    sha256 cellar: :any,                 monterey:       "e325724be7e6ef74e7dca00a264dfe740d47c989591bd0df6b7c331fff8fecea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449ee8b0286b964f0629729faf9034a0c90685afe5ea85512e940a668bf296fc"
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