class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.eduusersmooreacl2index.html"
  url "https:github.comacl2acl2archiverefstags8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 16

  bottle do
    sha256 arm64_sonoma:   "1f469b860575b85b1eccc0a2c601a546c5581b3adafc6228ccdf098d954c87ad"
    sha256 arm64_ventura:  "dec92c36988adb7bac8f4ffe21a01555be80824c44c242ef9b7bbca53a19886c"
    sha256 arm64_monterey: "41318ff41bc6a26a0afbc91ba0e296559e2ab9b50bc11f74b5de09a673632e40"
    sha256 sonoma:         "94eee19f7e4d6c45a4db59519f22fbea2e8294ba06cdf0ec8f76d2fb0353d821"
    sha256 ventura:        "14c9b64232b88554c492b10505cf8e9c780536a02729d45a65c380b16b26eade"
    sha256 monterey:       "23d941ed92db9941f5a746848ada3ec9154787813e9b35e5043465f1c40c02df"
    sha256 x86_64_linux:   "6720c928cb8ecef48eb111fcaafff770a4d4bd381c6c422f0b71ca8157997b05"
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