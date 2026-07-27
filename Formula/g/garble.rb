class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://ghfast.top/https://github.com/burrowers/garble/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "feab001d7e9ff4ce66011ebd70791de93eb1554d34d3ea44c33d102a25c1be0a"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1a7e4c1c62f5856e61b9d14cbc65a0470f2a1db63abc9daf769ad9de993c9e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a7e4c1c62f5856e61b9d14cbc65a0470f2a1db63abc9daf769ad9de993c9e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a7e4c1c62f5856e61b9d14cbc65a0470f2a1db63abc9daf769ad9de993c9e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec94f7e1177c6fc10fe16e9081e19d1fb66a8a7acc3d212daf49ff3dc4ad0834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cbf574da6fd4fcdafd18da8f53355264d69bda288495fc5d2bbae1e66ed97eb"
    sha256 cellar: :any,                 x86_64_linux:  "4ecf63a71b1484005ebbf108776759963c348ae107ce8bdf933c09b4fa151f7c"
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