class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.eduusersmooreacl2index.html"
  url "https:github.comacl2acl2archiverefstags8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 13

  bottle do
    sha256 arm64_sonoma:   "1967c08dbed5bdac25ef78cb85768c3f866fc9187f5ac40b87f2845ab8fb3005"
    sha256 arm64_ventura:  "932735041e2149bfb033815c24d3b029cf2f103dd2ca7754bf21b6b3ae622c16"
    sha256 arm64_monterey: "168ec07d1d3c0e18bbc45edfe860a122d596cb5a930df706b02d8adffb01de6c"
    sha256 sonoma:         "a3f27d88d25f6d0f5f9ac6f3e96cafeba8d8b0f127135a7bfdaa0bd709b7170e"
    sha256 ventura:        "769745afb8c0790255dc6f804631cd4dbe267e0cd043b9f65da33ae31784a711"
    sha256 monterey:       "580589e4d0dd2773e95a7e9d9dee90eaeb57a68e1ce4a5a38b2d67e1ae07a764"
    sha256 x86_64_linux:   "332d83c4b4d2879815bd986c7b8861b04461bbb0e0a6e8e7e80b78f6b929a540"
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