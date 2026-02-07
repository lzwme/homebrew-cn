class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.26.tar.gz"
  sha256 "c68b43ffb96020e873afaa345363da1121ee3c05c689b06d2ebf8c84adc6c9d3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13487c43a14bc386f92fb1712aafa5da37291594d530bfa4e3a4d86ea22485c3"
    sha256 cellar: :any,                 arm64_sequoia: "54812b0eb3c62fbed5447c021040297f0b5ca151574b0f4b8d68ff92193d661a"
    sha256 cellar: :any,                 arm64_sonoma:  "ac6145718942cec5a54d633471e6987f77078d358018a085c69c8465c4cb8df7"
    sha256 cellar: :any,                 sonoma:        "16e1c449d37d7ee8e165b7609b9d261d03c46493e5a5ffd4aa94cf8f6d30415a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9184a9d4c2b7aed97f4fc6115f48f3aa772e4954825e275d869c0df1d98d7827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348821a265adc25ba6e39f76dc1e58a9c963aa129b47fac71d596318fec70b73"
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