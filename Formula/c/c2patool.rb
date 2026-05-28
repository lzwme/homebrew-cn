class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.60.tar.gz"
  sha256 "6e0177357149819ac0586ead733b198b6a900c905cfecd9e0cd966cf32cc62a3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d02fb6093d2e0a4ffa3e43707758445913d1da1f31d421237b98bc17445c7b59"
    sha256 cellar: :any,                 arm64_sequoia: "6e8812ec05684c8aaf6eb4ab31cc4f025427f79d5d9aaae58552d7bed6b70ced"
    sha256 cellar: :any,                 arm64_sonoma:  "2d652aaea2dba92befd290fc0805f3801b68ab4ecaa48b07515f1485b6dd93a9"
    sha256 cellar: :any,                 sonoma:        "8b3a350b53b7ca4e5a8007f2a639a91e9fd6839dec2f2b9ba042377ddba9bae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1ceaec1ea9d37aa651db311e1c3acc1a3db91a07383d49e97054f58f254de0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4226a30d3363ad52f9759485dd349f52b6665d7198e593626e7fc2706891a80"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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