class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https:pkgx.sh"
  url "https:github.compkgxdevpkgxarchiverefstagsv2.3.1.tar.gz"
  sha256 "dcaf2e32f333b3ef3eb7889c4c277ef61e60ed09d216cfbf45ad1a1c38867ec5"
  license "Apache-2.0"
  head "https:github.compkgxdevpkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3442bf0ba5748bb19a4078063f1c851b93fff55118bc4ea2824b150bbaa053f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c15ccb801811e021199f586f2b0987aea842ef9d34c9cb15f382efb7d5a8071"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90a02dcf59927fd0de9a808362666ed2bb96657e315424b8ce0c025e2db6af6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4017b192e61e06dbd63d7b7b463160be22d9241f3fb821acc399ca6393eae1a"
    sha256 cellar: :any_skip_relocation, ventura:       "dfb1e42af628145d3890be9d3987d7276349e956426301d2306db4de970ed63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc119341cd736a284a82b506c7032a11a80ef9b16ab8a29d7c4388485b1cbce0"
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