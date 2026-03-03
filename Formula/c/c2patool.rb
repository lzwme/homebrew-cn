class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.31.tar.gz"
  sha256 "dae905559a9f6fb9da7bdfcf871eacec8f2e2efdef13248d7f962e38c6fdc4e5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86892f7f9297cd91123ee6b82e0dc86e66060692d88df34f3e8f13b3727aefa2"
    sha256 cellar: :any,                 arm64_sequoia: "7f27c07ece4b3776ea3518af997dca83309698f12ed6d2d7308152ffba683e8b"
    sha256 cellar: :any,                 arm64_sonoma:  "f2473287c7294a323529d954a509bbfaf49a362e3f2cf9bdc625e8bd6859e26f"
    sha256 cellar: :any,                 sonoma:        "4f759092d2c43ca553019777e04420851269f3d4b4eaae022164ba4c3882ea2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b65de8a34e08bdbea6e50e8f0524f020ee0e0aa3e3a9c36712bf5c689dd0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d41d99951788738cd95359b96be226d34baaf83c2923f2e92183b1986d165dd6"
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