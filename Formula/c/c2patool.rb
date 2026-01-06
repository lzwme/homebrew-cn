class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.9.tar.gz"
  sha256 "4ec44fb5ab357bb9c6b215e22de6a55b2f85b6c223919d06ad9bdd328f14088f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "626762749e2671f5474802bb4a27d82580462f68ac89a5705952c66f5d842374"
    sha256 cellar: :any,                 arm64_sequoia: "88eeba227027709447053d5fcab93c2536a1f7070622880c1f125ae5ed3c69d3"
    sha256 cellar: :any,                 arm64_sonoma:  "ca8053f56104ebeef7485437d4e3bf3b004c95d21c37b9ab122bb50970753053"
    sha256 cellar: :any,                 sonoma:        "d871f1a59571e1d26fbe9c169fa16b0d687db6e13a578dbab9959076df02f230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d742bda0a1390d6dff3c0864d306d2f21cb9402753b43af09bbbb25eb7865ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33867ba12a7119a68cc2420e353fe9f58baba7b87c871cd8d1815b3deb48fc9d"
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