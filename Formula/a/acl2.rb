class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.edu~mooreacl2"
  url "https:github.comacl2acl2archiverefstags8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 9

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "073848707280862ea6989156892024ef36608531ae91a5a8da6c43606ce1a82b"
    sha256 arm64_sonoma:  "e993d60fad118b3ef9c0f342ee62de84932fbe363bc03257a9abcdc7030eceb6"
    sha256 arm64_ventura: "5d5ca4120f7fba9d2b2db0de804fd569cc3664b848b3376b80c2e2b253a8b46d"
    sha256 sonoma:        "bfbfb6a517dc5f8b2d4d140fce15f03e539bc05737ec25828516c7335407fcd3"
    sha256 ventura:       "20116e3235de511e5ebda62810ac77c1c330ce1f267c107253cc194169d3d61a"
    sha256 x86_64_linux:  "a4b5cb3f381a7ba995e85d0ac4b763b17aa21cc7a4dee9e57b017fe59e5577c7"
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