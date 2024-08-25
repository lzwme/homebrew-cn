class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https:github.comdafny-langdafnyblobmasterREADME.md"
  url "https:github.comdafny-langdafnyarchiverefstagsv4.7.0.tar.gz"
  sha256 "f18f0f92ec00d5ab743bdaf0208fc1487a52e948ca72720b2bbc34374f812ba8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "020a5fb249da8a8ee49cbe96d5da92b7a816be5c7181a0f5bc0e628323601544"
    sha256 cellar: :any_skip_relocation, monterey:       "706f29051c0fc967745e62f901049e9d5f9b82884d2c7c4aa0b1354171cdf7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0358dbc8e9c76c3cc0100212424cfc65cf5e4b872ba28e2c1ca5a7c0a11d0e0"
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