class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.24.tar.gz"
  sha256 "4d81960fad9ea85a501f265082dbc533cfa820bc22a50bf51342bc7f69532658"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cd0815ae6ab8ae53ae1bd5b8d5948420b6a67287e20a63fcb6cb6523ad38082e"
    sha256 cellar: :any,                 arm64_sequoia: "0560432ed65f5a2e9243e7296e2520a58547c28a46ed9fbe914dce32b07b087c"
    sha256 cellar: :any,                 arm64_sonoma:  "1cd55aeac35c07fff5861df47ea237b2e4844013100b2b96b2c77810632d1586"
    sha256 cellar: :any,                 sonoma:        "2f418e52bfed1446509e1a4670c5eb8232514e809933084e3c2bdaf0cff77885"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "902e9b17b66f1c3213f13cb402110319e15c9ddfdcd90f6da064605dfc03d92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e031536876c0339b2305d90ef4f6abeb4ccace743b60090f0a6fb80992e9e007"
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