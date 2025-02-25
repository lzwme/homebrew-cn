class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https:github.comrogpeppego-internaltreemastercmdtestscript"
  url "https:github.comrogpeppego-internalarchiverefstagsv1.14.0.tar.gz"
  sha256 "6d2c3c05a2ace6d7aeb825fb39011506bc33a61a0a120481ba649a25b42e9f58"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca475c8cdcede0e760e23157e5d4c994de35bce7498350bf515a3e996d246f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca475c8cdcede0e760e23157e5d4c994de35bce7498350bf515a3e996d246f4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca475c8cdcede0e760e23157e5d4c994de35bce7498350bf515a3e996d246f4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3fb337e2a76f2de8a9c619dbb4bb8a9792dd07a5f2be8060714a9747bd1282"
    sha256 cellar: :any_skip_relocation, ventura:       "dd3fb337e2a76f2de8a9c619dbb4bb8a9792dd07a5f2be8060714a9747bd1282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34281b32f4cfab8f7d2f8f7ffea6822e8e38213da4c4bb465c9c0d010de52d23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdtestscript"
  end

  test do
    (testpath"hello.txtar").write("exec echo hello!\nstdout hello!")

    assert_equal "PASS\n", shell_output("#{bin}testscript hello.txtar")
  end
end