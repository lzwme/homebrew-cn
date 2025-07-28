class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.5.7/sbcl-2.5.7-source.tar.bz2"
  sha256 "c4fafeb795699d5bcff9085091acc762dcf5e55f85235625f3d7aef12c89d1d3"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66a0a3269ef4838fff841e5ef0508b6f396893eacc4b28d44221f32db4745490"
    sha256 cellar: :any,                 arm64_sonoma:  "7199583f6f6233d480e6b622d22ca8433d89d68fd5e1bad8f86e556b3aee12c7"
    sha256 cellar: :any,                 arm64_ventura: "7a5c843ad6248bdcda665ee6b5fb0f7b9b07e23ce7d1255ceb7ea1fda297d580"
    sha256 cellar: :any,                 sonoma:        "f59fe3477704a8e42a82c3d2f99eeebb7a4e8e442a570109fbe42cd854fc60b5"
    sha256 cellar: :any,                 ventura:       "846d46822f1790d55cb6bde4a42e3799e7b314089c5556ac1ccb6b5fb41c24c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d760fa69d0222f6d69d10b99e23018076a7b677287b59104f320ae3e34e24682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0761796a62f53b70b7dc325f9fbcf4403f92cda6b6583f712ca14d06fd6f5e98"
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