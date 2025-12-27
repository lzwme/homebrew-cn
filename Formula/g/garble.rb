class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b429b24dafa851a25bbeca635db33eb4162b8e3109fb234a2c8e7780a837b958"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2316f3c47356373f8a21cc3e81a07227f9a1f3e35d9acd77d6b2da2817417b54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2316f3c47356373f8a21cc3e81a07227f9a1f3e35d9acd77d6b2da2817417b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2316f3c47356373f8a21cc3e81a07227f9a1f3e35d9acd77d6b2da2817417b54"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f80442d06943458ffd8d914aed55637acd34083e958d9e9b9cd509721880f0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c886c2d9a825fe4ce5659d267cfe7056e6a834bf0d47b91e34a8ac105e3df068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1127204df224fcbc59bde24d2d38deae1e37d96ec51d9d6eb661ffe046c00d6a"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # `garble` breaks our git shim by clearing the environment.
    # Remove once git is no longer needed. See caveats:
    # https://github.com/burrowers/garble?tab=readme-ov-file#caveats
    ENV.remove "PATH", "#{HOMEBREW_SHIMS_PATH}/shared:"

    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end