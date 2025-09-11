class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.22.0.tar.gz"
  sha256 "095c6f0720971c17fd1c11b22f78786b6b88d5dd967fe3926e67d1655aee9151"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b75efa9aa64642ea2257a871ea17779f5d0fcd70bb3bce696859a5916a0c6f9"
    sha256 cellar: :any,                 arm64_sonoma:  "c4966fdf9104375ffe21604553aab977ed9147855c57044d91d23c1e6dd65002"
    sha256 cellar: :any,                 arm64_ventura: "e239606cbcbcedfa108676cccd1784e2aacdb51bc28b5cba5e8da7460f56c79d"
    sha256 cellar: :any,                 sonoma:        "c21db3142c3684c24504f2d2f8f6c4fc0262e480ccc291b173a2b55f03c6b689"
    sha256 cellar: :any,                 ventura:       "337088c7b1bc4fd4c617107f0245db3f41d1b32c2eab9978f995da02d215391d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07218474b6e4378995ec8317001cdfc49f113aac8c58ae964391533581152d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1791bcce606fd2c8b70904e2d39cd37b64ddf051fe87b7930c7c4993394e828"
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