class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.3/sbcl-2.4.3-source.tar.bz2"
  sha256 "89c9aadf92b82ad3c74a3d4f158a038893dea0e4f394dcafc963583c30b7c3f2"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d7c1be702aa6997b698477fe49dac927b1ccca6748f113da2b5805d01de84e6"
    sha256 cellar: :any,                 arm64_ventura:  "cd1c424a51e48ed8a257eae5c01d66e2c682765c3c3d322215ce1b8425607c9e"
    sha256 cellar: :any,                 arm64_monterey: "72fb7256e765578e2e8322eba32134e4764580384777a2d01668a464974cf0d4"
    sha256 cellar: :any,                 sonoma:         "4a5196d3d67076ffda32da53e266987a9d5e394bbac58b063a4fe2513c4e077e"
    sha256 cellar: :any,                 ventura:        "e9c3b9dcb8b2719212a9b6b7bed7d811cd26cdfe4622daf09979fc32b7a32357"
    sha256 cellar: :any,                 monterey:       "ced1b0c0da6edaa98b0efecf8ecd0d313a2eea0cb4d0608c2f505f57d11382de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17aca8e915e6c364dad9114bb57c3bdd92cd163644ba4ddcc7d637f4d3b914a5"
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