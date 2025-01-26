class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https:pkgx.sh"
  url "https:github.compkgxdevpkgxarchiverefstagsv2.1.2.tar.gz"
  sha256 "f6092708ecd11b9af557d79b1396f98fbe550992dcce8efe704eac9f57ebbc4a"
  license "Apache-2.0"
  head "https:github.compkgxdevpkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24b987845d802a9d0800e356175d6db3a32405c63c978ab951397eb9456d1f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e717ecb1e35d68a06ca70be4403c1dbc39b9e19f9b616a86b91eaaac2beeed04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c201c5706df4c97d10abea71ba322ec91e2887f64c8087ecd2dae0af0788c956"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c36f34fb8fff35b79f23815426d87ce9f66aa4cc8949b7e0b769442f42e708b"
    sha256 cellar: :any_skip_relocation, ventura:       "2725dd827f674d231a7872d894206fdb64dda96c6f35a9872f3c1beda1bced2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312eb804fcfee04a8f74714b920095e654c3f1ddedf14af71f32ef338e004d98"
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