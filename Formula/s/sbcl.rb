class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.3.11/sbcl-2.3.11-source.tar.bz2"
  sha256 "84beeb8d72c87897847fc0285adcb3fa4f481bdb39102c4fb9ab79684184ad29"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13ac05dd193df6fa9568373e07ea7eca25694b2433ad83f1f1d7758fbbb2f92c"
    sha256 cellar: :any,                 arm64_ventura:  "3dfdd0becb860781cfe8ae34353842261e3001d7d1ee885cbd22b210b1a430aa"
    sha256 cellar: :any,                 arm64_monterey: "7b82fd7dc8a638cdcf220b23cc81c3eb4bb11d71dedb2aa1b7b3dc9a714f51be"
    sha256 cellar: :any,                 sonoma:         "97049781408a565ff7a3d0e38ad0c3c20138aecb3e76cca3a24cdcbeab119b16"
    sha256 cellar: :any,                 ventura:        "bbdf44ae59dae2909ddbc25c0ebacd700971594c3a06a5a762841964301e4459"
    sha256 cellar: :any,                 monterey:       "a033a7786109bc714b174c1f6d63a7554a778c6cc44b4b577318cb85dd0ecf14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb553075186dd0f9ff1e126bbf960674d5e09fc1a8bc5a0662837e316eb0e93d"
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