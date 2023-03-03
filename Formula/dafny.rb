class Dafny < Formula
  desc "Verification-aware programming language"
  homepage "https://github.com/dafny-lang/dafny/blob/master/README.md"
  url "https://ghproxy.com/https://github.com/dafny-lang/dafny/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "8536bc0650e3801cfb21bd0fc65d2c802940917eb572719d0695c763765c2ea0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb2e5af4b30628859f2f3f7ce1b696ad9ecdb007d4def6c986b666abe8cd175"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d185a2006fa15c829d292c028d11cb647736296820a6e8a381ce6f62ac3b3f88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec3479c309a967e4eb70950fe4cdb169a26d1a7cae14522b51b4841f33ee2653"
    sha256 cellar: :any_skip_relocation, ventura:        "5e19141d67faa259296513b4a66e41c21b0e38a42e21865fc11fad78fd99ef32"
    sha256 cellar: :any_skip_relocation, monterey:       "61a99305fcb989115d173c44a91b3c7de26577a931fb2565ae8b36421c201026"
    sha256 cellar: :any_skip_relocation, big_sur:        "46ff56f12ddff5825e8479a9d7697dd9bf1d84ed690d70ef2ff8f2958907ac28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a2a52b0e65a99455f164a9113cf519795c47a853adcca95c6b37769bacec383"
  end

  depends_on "dotnet@6"
  # We use the latest Java version that is compatible with gradlew version in `dafny`.
  # https://github.com/dafny-lang/dafny/blob/v#{version}/Source/DafnyRuntime/DafnyRuntimeJava/gradle/wrapper/gradle-wrapper.properties
  # https://docs.gradle.org/current/userguide/compatibility.html
  depends_on "openjdk@17"
  depends_on "z3"

  def install
    system "make", "exe"
    libexec.install Dir["Binaries/*", "Scripts/quicktest.sh"]

    (bin/"dafny").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@6"].opt_bin}/dotnet" "#{libexec}/Dafny.dll" "$@"
    EOS
  end

  test do
    (testpath/"test.dfy").write <<~EOS
      method Main() {
        var i: nat;
        assert i as int >= -1;
        print "hello, Dafny\\n";
      }
    EOS
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\n",
                  shell_output("#{bin}/dafny /compile:0 #{testpath}/test.dfy")
    assert_equal "\nDafny program verifier finished with 1 verified, 0 errors\nRunning...\n\nhello, Dafny\n",
                  shell_output("#{bin}/dafny /compile:3 #{testpath}/test.dfy")
  end
end