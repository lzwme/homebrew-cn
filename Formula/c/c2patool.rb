class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.30.tar.gz"
  sha256 "b5f8c5abe4f38fd95ef4e923e9ed4c45219d96369e5c44f704aaee334f8fbb53"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c80e9e0a91d87aa5cbdc5a9f9ea3dbc4a45a2c29b83002b936e0866daaa28c1"
    sha256 cellar: :any,                 arm64_sequoia: "10722c5c3ee7bca2d0bbc9fb1a2b2f1a43639926ba7c80bdfa2eef58572627f9"
    sha256 cellar: :any,                 arm64_sonoma:  "b34ddc1239d2741044ac7024736eed6a07e1207030d55e6b962b4a1511429e19"
    sha256 cellar: :any,                 sonoma:        "fb1fe26b5d482c1bd9fa4acb6cc3f013cc5b34b91f97ff91795d637d05c402ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afc1f1c2085f9af068a4c2a954c5b1a29ed92ff4024b0d7435dcd3abf369c55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c724277b7d99deea95c9a87fe0a334f1db26ae1e2ba25fbf18b81e143d6e2d79"
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