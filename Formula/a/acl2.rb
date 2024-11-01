class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.eduusersmooreacl2index.html"
  url "https:github.comacl2acl2archiverefstags8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_sequoia: "ccb95a431adc877dd21d030bc86d487c8f874abdeecfbc30bf06a214ab823b68"
    sha256 arm64_sonoma:  "38776189c5231e7c8e01be170bfc54c599aa84705871f892a17b0a2640e5d270"
    sha256 arm64_ventura: "d4ca7c648675236242e5c77ca226a50a2b58dd7d0a89afd8508d124d14595905"
    sha256 sonoma:        "f8e0b1c7e668802bb045d83de42dd72b908fdbc6fee53c8281f4f913a7776305"
    sha256 ventura:       "f546c59b3f7d510abd2243f7829b53175f16d7ac263edefc35f70732282d5a5d"
    sha256 x86_64_linux:  "4caaba70131197f6d2eb408622360e02684fc8b0ae5c302c565d43d79ed9de2f"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt binaries
    [
      "bookskestrelaxex86examplespopcountpopcount-macho-64.executable",
      "bookskestrelaxex86examplesfactorialfactorial.macho64",
      "bookskestrelaxex86examplesteatea.macho64",
    ].each do |f|
      (buildpathf).unlink
    end

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