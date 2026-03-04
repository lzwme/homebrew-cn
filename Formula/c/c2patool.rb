class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.32.tar.gz"
  sha256 "f58ad79d78db0d51d6fa2f7cd0774680385ff7b578814c336ea69a43250a138b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "89a47ac40ded16d9f8ce7c653e8928228b6c01d4e5676948729b4cc8e1149056"
    sha256 cellar: :any,                 arm64_sequoia: "151a3d52d2b1cd7fd6ff3f50401894d1d508c11327de895186a14970409b418b"
    sha256 cellar: :any,                 arm64_sonoma:  "63925f1798b70acee1ec2bc7dc269dac117442e50d1972a26431c2e85b11796c"
    sha256 cellar: :any,                 sonoma:        "f21da7d4a1c76c0459b953f60ef721f16da13fd451d8a5ead1904fbd527f5496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0234fb8f3f3018ac59ce17225c2831600650908a442a61836428ac2290c1c952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e5ef92c9d89530bc4c142320df751ee96642803b9763f3f1bbecc4db48b67f"
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