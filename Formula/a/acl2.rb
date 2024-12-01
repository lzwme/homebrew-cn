class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.edu~mooreacl2"
  url "https:github.comacl2acl2archiverefstags8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 arm64_sequoia: "7389b91b5a8def3f601e86ee44b7d0fdf76c410d638b8861b7ec54163e0aa432"
    sha256 arm64_sonoma:  "edb6dad5e33af178aafdb77a035f4de41f9f8496e8a7bd88755310ffc3dd5afe"
    sha256 arm64_ventura: "20c4d2e868a521fb1b1a77b07ce14b7b2baa61690efcc25f329a8bc7092be542"
    sha256 sonoma:        "8f4f67afabf0a330cffcf0e621666b67a2b2d905a1b52aad0a0f4b6f83ad215e"
    sha256 ventura:       "536019cf0e54e638655cb13700c41615bbb3e5671e8abd674ceda98b40d4a7ef"
    sha256 x86_64_linux:  "16a88964f198ac5e1d73fd7b1a74d0fa06c433cfc63e91fc78ddd19afb3eabba"
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