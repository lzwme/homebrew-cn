class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.9/sbcl-2.3.9-source.tar.bz2"
  sha256 "7d289a91232022028bf0128900c32bf00e4c5430c32f28af0594c8a592a98654"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d8045d3100725010971b0f5bd1d6ddb6e79e4d74b210c6ca27a2ee55bd0cdf5"
    sha256 cellar: :any,                 arm64_ventura:  "5af7c22b3c64eaf205c85b3dfe495df0faefdca7d1d13feba8c14594aa91308e"
    sha256 cellar: :any,                 arm64_monterey: "3cf2aabd6d589ab039b1a0f0a12ec215d24fd0c89454fbe07187fe90a37fa1dd"
    sha256 cellar: :any,                 sonoma:         "309b1ba9e2f57fd24291546d35907df07750412a4940b1ceb33a6baa37b50b6a"
    sha256 cellar: :any,                 ventura:        "3a88e7a7a4c53e2d4a4843248528c2e6cdc6e452180551463577245a6b81b593"
    sha256 cellar: :any,                 monterey:       "530393b671d6ff6c1d125a027499300e05ff9f51ced5e61bb026ad0d391e4d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19efbf4fa79c6e232c898745e497c5759739b8a33fd5721cc3a095022ad70dc"
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

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s
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