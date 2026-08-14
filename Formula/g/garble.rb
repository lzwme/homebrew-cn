class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "feab001d7e9ff4ce66011ebd70791de93eb1554d34d3ea44c33d102a25c1be0a"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79aa754be7df29d8c317bcc67be29a3fd03c4563ebec971429a8d7052e61635f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79aa754be7df29d8c317bcc67be29a3fd03c4563ebec971429a8d7052e61635f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79aa754be7df29d8c317bcc67be29a3fd03c4563ebec971429a8d7052e61635f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc9b42154a3e9b913d58ffebf0665950a287e7fe2e144dcb12f895cc553879b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "403c8939b0cdb4ff980c366452ecb83f020c95264a51c64461adc14a1db91a26"
    sha256 cellar: :any,                 x86_64_linux:  "4c540fa76667760aa0637acdf2ff9915ca6d51cf46bf9e0ec413a1401962a2a0"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args
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