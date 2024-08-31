class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.8/sbcl-2.4.8-source.tar.bz2"
  sha256 "fc6ecdcc538e80a14a998d530ccc384a41790f4f4fc6cd7ffe8cb126a677694c"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3900463109b5283c27d311b8955a3fe4eba0512c2478a93032ec0bb413b217b5"
    sha256 cellar: :any,                 arm64_ventura:  "a2fae4d961359fa7303b943a8e24e803b3ce2b01b799578ef5ba19309cc7f7b6"
    sha256 cellar: :any,                 arm64_monterey: "c32a48dd2aebf829bf4a81e4b2c5a24ff813985ab31e0a228bdaea3ebba8bbd1"
    sha256 cellar: :any,                 sonoma:         "e7f6f0baf97976af8b0e5b92c3e96591aaabd792eb375ed3a1217e06021094f3"
    sha256 cellar: :any,                 ventura:        "463b141bf0da5ee9d23e9047b4e4be32691b05d3541b66a1040316c2e5f1d5ae"
    sha256 cellar: :any,                 monterey:       "fc70337c07e4fcbbfd36cc4b067eac0896248e45c2a4f6004e7a52fe6ee33e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "451a77c0eaa77dee7845fe2b078550c372ee1c19969bc08f997ddad79b5cf031"
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