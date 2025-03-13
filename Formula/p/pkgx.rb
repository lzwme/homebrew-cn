class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https:pkgx.sh"
  url "https:github.compkgxdevpkgxarchiverefstagsv2.4.tar.gz"
  sha256 "30fa5903eb77658b9df007e1f422e4788513992400925f843c705b5f4b91a43c"
  license "Apache-2.0"
  head "https:github.compkgxdevpkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c9762a9ae8f05c202513a27bbd4e91d863f445dd8cbdb803c5f2c243bdf158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f204198c3fbd09bec70c24270f4cca5693282cf79614f4d5c3ec157a4377d880"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "935ee645027dcf5412c089949f3a5c3a341f4d273ee01b0a1d7ab132aabd231e"
    sha256 cellar: :any_skip_relocation, sonoma:        "76107a95b48e28b983f00664fd7d70f88a06c92cd148059e0c2e5033193a4a01"
    sha256 cellar: :any_skip_relocation, ventura:       "9de9e043762362bebfde0bc89fabeccf35db021e361bd24ab6ccb9dec349d9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c4ba9a40187b17191f255cc91444e55391336b8011bfc5d0b1e2cea04c3bb9"
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