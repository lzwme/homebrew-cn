class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.33.tar.gz"
  sha256 "280bb6e5d2d8275eadfc0683f43e4e678ce43693ee7bba08830629f1a5d1f424"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5f7bde9141c38ae64b21ee32af797508fc75dde102beeadc9ce23c4ed5a8165"
    sha256 cellar: :any,                 arm64_sequoia: "e53d983d17fb1a76e26f51f230a6a5cf5ebc6a0928ac16f9e21ccb5623c451db"
    sha256 cellar: :any,                 arm64_sonoma:  "390feb16a3d3657e9783f1e1a1588e801b8ff19b0bb83d608afb2c7e52eed688"
    sha256 cellar: :any,                 sonoma:        "4ecc6bf8641305223bb385dca9ba2a5d32399332add5511fddbea59fe38c0687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d00a767604da68a57615cf0ebc8ae03f6955a46cb3cbaee16752721bd760159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "face11365290d8c24f578d4ae2feb5059f633d158c975b98650061b08ed2035c"
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