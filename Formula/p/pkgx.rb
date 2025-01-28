class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https:pkgx.sh"
  url "https:github.compkgxdevpkgxarchiverefstagsv2.1.4.tar.gz"
  sha256 "261323133af65199094874b913d1a1e4b839d3e8ca4a78963c1eab9305de8ee0"
  license "Apache-2.0"
  head "https:github.compkgxdevpkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f8853f2534190e52fa6ae64065310b34e07263e9e9706f0d6ac8cced2d4d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e080b8b94eda0c845134980264b86f9597af1e2132d4a99140f1be9a8725b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9583b88efbb9face3f79262c9b33fbb01022e34d4a8d85e3c84393fc00bea89d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9e71538a5d7cd0bc6d2a533c0fe9432bcde98f47084d60a3103f1fbf46f3699"
    sha256 cellar: :any_skip_relocation, ventura:       "50fee13e93da191c1b96808497180a26730ca6188858f19cd26a86e958399a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ca3cc494ccbedd82fd662ef72fccd3ec0546870bade6bd71706a66b5499b91d"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cratescli")
  end

  test do
    (testpath"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}pkgx go@1.23 run main.go 2>&1")
  end
end