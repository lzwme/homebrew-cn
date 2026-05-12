class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.57.tar.gz"
  sha256 "e42e2b04b94333c8f8429b924061459b8e60230b385ff34d7b49eff2a5bc488f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd1f4b60078657e6854899d72b5a002667d52d098f91c0b4167226c779acc031"
    sha256 cellar: :any,                 arm64_sequoia: "324cea53f4b18a257933fe33b820a4f353d0a283f3c49e964c224928b84c577d"
    sha256 cellar: :any,                 arm64_sonoma:  "9868243671e6d9a76a7709e904c58e421ec35111872e1487ad69886121d4ac8e"
    sha256 cellar: :any,                 sonoma:        "329ff2801c5dc56710734de6c9142eb6bdb44b8f95e72fc534e9e95ab2f2978f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1367afd8c2f1259f83b4bb6a77b340040350f007c80eacaf710165782a402f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708e8fd3ef9d7df1a712e9bd1b0c86c4df8b07b3e2530c5dc1ba79daf71fe1d4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end