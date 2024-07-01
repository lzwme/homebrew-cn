class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.eduusersmooreacl2index.html"
  url "https:github.comacl2acl2archiverefstags8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 19

  bottle do
    sha256 arm64_sonoma:   "b49a1ac73c2edb3c5892d6577a08d493ec8514063fa17fa76fb8f23d12df5c8e"
    sha256 arm64_ventura:  "06568cf18f5296280fa557c2fab291797d3a33473316ad89a3b3ff24a422433f"
    sha256 arm64_monterey: "420471d61a0ce53097617174fc58463cbb0a96b21285d2a10f5a561e4679c313"
    sha256 sonoma:         "a08a85fd22a7063a59401d74b6c4c4a6721f5e762c6265510ba2045ea9e0b1fd"
    sha256 ventura:        "97611bcb7adb12aa4139130272c2a7f4010f4c92b8c05c050061970b004db6f0"
    sha256 monterey:       "4825113270f9f8482596560e9d9ee0d9204c4a63401d8bfa038eb98716824165"
    sha256 x86_64_linux:   "2409fc418fcdabe832b8900a470d823c89e677f874beaace78aaf3068aafac7e"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt-binary.
    (buildpath"bookskestrelaxex86examplespopcountpopcount-macho-64.executable").unlink

    system "make",
           "LISP=#{HOMEBREW_PREFIX}binsbcl",
           "ACL2=#{buildpath}saved_acl2",
           "USE_QUICKLISP=0",
           "all", "basic"
    system "make",
           "LISP=#{HOMEBREW_PREFIX}binsbcl",
           "ACL2_PAR=p",
           "ACL2=#{buildpath}saved_acl2p",
           "USE_QUICKLISP=0",
           "all", "basic"
    libexec.install Dir["*"]

    (bin"acl2").write <<~EOF
      #!binsh
      export ACL2_SYSTEM_BOOKS='#{libexec}books'
      #{Formula["sbcl"].opt_bin}sbcl --core '#{libexec}saved_acl2.core' --userinit devnull --eval '(acl2::sbcl-restart)'
    EOF
    (bin"acl2p").write <<~EOF
      #!binsh
      export ACL2_SYSTEM_BOOKS='#{libexec}books'
      #{Formula["sbcl"].opt_bin}sbcl --core '#{libexec}saved_acl2p.core' --userinit devnull --eval '(acl2::sbcl-restart)'
    EOF
  end

  test do
    (testpath"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}acl2 < #{testpath}simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end