class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https:github.comociclocicl"
  url "https:github.comociclociclarchiverefstagsv2.5.15.tar.gz"
  sha256 "b89624bd0983835d233592150fe84de1e8d5e0ab4c481e9e0947007b472c14cf"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "0420a539d12601ebd1eb39c905130b684a4f955ba20e8d51daaeb0b7f203bfb9"
    sha256 arm64_sonoma:  "cf9eedab93e85f9e3e1f2000401842796f59802e67eef97563dfed2d3052039a"
    sha256 arm64_ventura: "6ed70be44711bbd6941a7bcddcc697235ccd2d8527a64bd4297f0eb7b7396581"
    sha256 sonoma:        "324838b5c87f61034bd13c02cecabc7ba111db1fa1ede647a899c28f7ae71338"
    sha256 ventura:       "a57c4e32e53c1ebcd8eec44902a89fcddc06ac73b1275a8c4c5208fad4c2431c"
    sha256 x86_64_linux:  "fbcfd9bc93e267e20e606deff98aa2212be34de771e36f53382e2b0b78c783e1"
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