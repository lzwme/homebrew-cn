class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.11/sbcl-2.4.11-source.tar.bz2"
  sha256 "4f03e5846f35834c10700bbe232da41ba4bdbf81bdccacb1d4de24297657a415"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7dc04253b55b2daa833fa188dd03f5c678d517c2b15419fee92454ce227af2ee"
    sha256 cellar: :any,                 arm64_sonoma:  "9c85439fab3c7cf5ad18277fafff399a9c49f35118838b3c922a86761c6dd472"
    sha256 cellar: :any,                 arm64_ventura: "b78282ee62fd068a7238be203018a545a595a2267b49845edc13f0f93c78ff45"
    sha256 cellar: :any,                 sonoma:        "a6665fe268db5998d6b52e1f0c578b26f7b1af65522d8a8dd25c36c07f50f736"
    sha256 cellar: :any,                 ventura:       "3c16b9cc8bcfa5c3b81dad0da8167105876a4059dc13b67f5570e7df5db84b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93fa37499a177630fd4b4941343da90c58d82f76531f5d576d1acd0deb684abc"
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