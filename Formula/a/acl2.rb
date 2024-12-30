class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https:www.cs.utexas.edu~mooreacl2"
  url "https:github.comacl2acl2archiverefstags8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 arm64_sequoia: "dcd8489f05c6058c3f1fdacb51d5a3c2e1edcba4f440a727f7385ee61bd597f3"
    sha256 arm64_sonoma:  "4e0c32045c152b90f99e54db31907123aed689f440b78f702116245011782a91"
    sha256 arm64_ventura: "d1ab3a6a264a815bbb35894c5a0289f7373114612af79327a02a3cbc28159012"
    sha256 sonoma:        "5ad7baa472f3d9c0a1ee26737885ab5c71dd8fc1346c56cbaeceb2e34d35e4de"
    sha256 ventura:       "c0e602dd79e2d4c3ffd444967d9b49c13b10e7448a2428fe611e673e89b5dab9"
    sha256 x86_64_linux:  "094a620e996e5f417330a1990d225dc51423785c023575d191c8de44be215d8d"
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