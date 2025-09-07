class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.21.0.tar.gz"
  sha256 "c281c5be60697f92d79a2f8f47fd8cce26a307add1216a5f8065bb5c400c77d6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ddba909158675310c6e7eb9ef16c5e3a8fd4c4a699c58b898afa2067f83bc0a"
    sha256 cellar: :any,                 arm64_sonoma:  "7ef118d40663bcf11044fcb5216668ace69595e73a28be7c17cc342ee4676dd0"
    sha256 cellar: :any,                 arm64_ventura: "b267aac9af4a657bcf5436a85190d0b82266b6560c895f6c3850c2b4badcbad5"
    sha256 cellar: :any,                 sonoma:        "992e3a963313536e2765b5d0504df9fd4f5296d715234024c176f1bcbb9bc3ff"
    sha256 cellar: :any,                 ventura:       "d6c62b6b49b45cb00628ba144a036f53f7a56362f8a8409974c7eef091ba03b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ced29b6a9c1dd5d4f7bcfe9942ef789eeb8b950ec52d69535a78580973563024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e7da725637923f2e972f0dfe1fa88359a72635d77b130cdad11ea51e05e823"
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