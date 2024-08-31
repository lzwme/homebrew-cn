class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https:github.comdafny-langdafnyblobmasterREADME.md"
  url "https:github.comdafny-langdafnyarchiverefstagsv4.8.0.tar.gz"
  sha256 "07799a0500bb45a5d57faebe181690a7fe93379706db2904552d236bd539491d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b98343389c54f29a8bc88b71594a17addaa4c82bf0fe2f7b0e2e94a587e5b655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36f6d698947d7dbee1c03156a329f53c4770d1038fc27d1a4b7172b5c92764d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "abd78e9a8d15d585793a79039ee659beeef8aefb93144af098916829391797a7"
    sha256 cellar: :any_skip_relocation, monterey:       "2f98c4550316286c747157c067a608dab0a3dec08062fe87eb5fcc0c610c1882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37db21d113724ac2c4d1747894b88bd82e633bde21a7cd49bbb40ad914cf2709"
  end

  # Align deprecation with dotnet@6. Can be undeprecated if dependency is updated.
  # Issue ref: https:github.comdafny-langdafnyissues4948
  # PR ref: https:github.comdafny-langdafnypull5322
  deprecate! date: "2024-11-12", because: "uses deprecated `dotnet@6`"

  depends_on "dotnet@6"
  # We use the latest Java version that is compatible with gradlew version in `dafny`.
  # https:github.comdafny-langdafnyblobv#{version}SourceDafnyRuntimeDafnyRuntimeJavagradlewrappergradle-wrapper.properties
  # https:docs.gradle.orgcurrentuserguidecompatibility.html
  depends_on "openjdk@17"
  depends_on "z3"

  def install
    system "make", "exe"
    libexec.install Dir["Binaries*", "Scriptsquicktest.sh"]

    (bin"dafny").write <<~EOS
      #!binbash
      exec "#{Formula["dotnet@6"].opt_bin}dotnet" "#{libexec}Dafny.dll" "$@"
    EOS
  end

  test do
    (testpath"test.dfy").write <<~EOS
      method Main() {
        var i: nat :| true;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}dafny verify #{testpath}test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nhello, Dafny\n",
                  shell_output("#{bin}dafny run #{testpath}test.dfy")
  end
end