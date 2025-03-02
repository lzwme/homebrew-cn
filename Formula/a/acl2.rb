class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.edu~mooreacl2"
  url "https:github.comacl2acl2archiverefstags8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 5

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "948b994db97b785fb9c3a9fb5392ba6b907c7842c759a8f1e6f97db35627b7ef"
    sha256 arm64_sonoma:  "94e1bdd88263445bd76fa62a77236fff2d184d23bed1785e05eb1bfa0c984a41"
    sha256 arm64_ventura: "c82b192da523199fb50f23d79fe99febbf49e4485f3c2ee04c60143a7a90d37d"
    sha256 sonoma:        "0b8ea627aa6bbb9006d6fcbabdf86afd72c8c72bed9fdaaf60b5d1bd2723e6eb"
    sha256 ventura:       "b8d1f036ee6b10402fd4d667d67d17a7ea7bce126217f7af7351edd40913fd97"
    sha256 x86_64_linux:  "c1146e061adf30ebd28f87ba6b9903b864bd253942b546aa43e1b325e68fc5e8"
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