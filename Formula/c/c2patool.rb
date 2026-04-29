class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.52.tar.gz"
  sha256 "2a9806a141220cc737f4cc0c54463b9040119afef1fa2bb3a0a46acad9653c3f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2cff34581ed0b78b2d14f5253ad13191d5c820e490f8892cff49db89d3d9ac5"
    sha256 cellar: :any,                 arm64_sequoia: "fa1d55cbbaf5700e78d26f79f454ad432f11a753bd1e7159fc641c8f9a730fec"
    sha256 cellar: :any,                 arm64_sonoma:  "ac87e53c28815904e35ddccbc45f708f55f0bfd4cac077c69dfe625e7496c8c8"
    sha256 cellar: :any,                 sonoma:        "36c5994b9aaede7c736a88a74a6900c3685d486d4f4b9475bb200d6a6c565dab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5164c3b6a6f95fd0e06e2e4ee8236902ec54d7bf2d590229267dc9b8554c3016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15ddc9f192b1684e65dc23a3644d51cbabe71c97a68c5296e2305ed47bc95a53"
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