class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.6.tar.gz"
  sha256 "36ab0110528da89840320a2e6a534c6effd74af8041d0ad6c62c8f754f0c29a8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ed8190d2acc0063b54df4e20c62931429f4f7004bad144e70deb907ca994552a"
    sha256 cellar: :any, arm64_sequoia: "792e447daa617a403393a5004af4c13b58edb59fccf1c3cabd022058224f6b4c"
    sha256 cellar: :any, arm64_sonoma:  "455a106e2f81712697b4f1011e9609acf2494417d933375943d547c0a0321d74"
    sha256 cellar: :any, sonoma:        "de4952396f966f8437569234b0dbd7571b1af569172f188318970264df531546"
    sha256 cellar: :any, arm64_linux:   "c343611b466ec46484f8cf4f60723b040baac5fa8652ac6e0525351cae5dd46b"
    sha256 cellar: :any, x86_64_linux:  "21809c52564d4e0b4d3e6a3bddaad585a69e143b600c55f2e001b7bd48989ebc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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