class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.20.tar.gz"
  sha256 "a5e87e5880bb5415e9a4cdff4fd4334fc2a19a497c7aca469f359f57675eb913"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "6da00308938406dc535c0cf9fc6e201a6fe05e739a96f2bea3abdb200f3bd27e"
    sha256 arm64_sonoma:  "7d963b1c25f82b11a89debd3efebef6ad860a20c25c1f1ffe312098b792c65c6"
    sha256 arm64_ventura: "a0e5ed798702e26b6512f0289f7ad5aa3b12314fb79f62aa0ff7fb5681c03b17"
    sha256 sonoma:        "a13f556ac030a51de7d48e279faf65ccd38d8b419eb451bb808ff3d18bef4b4d"
    sha256 ventura:       "dbede385b0c9ca59836bb97e39e4582536f64f51dd45ccd44fd2133780c388b9"
    sha256 x86_64_linux:  "ee78c7132c09e8062570a61e65c002519f38307726bbfbc89d4469a089c78e91"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtimeasdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin"ocicl").write <<~LISP
      #!usrbinenv -S sbcl --core #{libexec}ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin"ocicl", "install", "chat"
    assert_predicate testpath"systems.csv", :exist?

    version_files = testpath.glob("systemscl-chat*_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath"init.lisp").write shell_output("#{bin}ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end