class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.64.tar.gz"
  sha256 "4cbe7cb53c12fb1739262a798fca0bb06389f2c3866af28d39e4f3723642dd4f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a82c7cdebd14f5973e78c5c9cc18f6da49d97e7625e35adc2c1b0176a63b78ec"
    sha256 cellar: :any, arm64_sequoia: "02e82a504c8f7db465eb34ee1b2864f3f49a5c5ba1907524991fa61f59578d1c"
    sha256 cellar: :any, arm64_sonoma:  "c2cda8b93abf0b57751c58193a385dc78bb374d8a6513037678ae867f540e426"
    sha256 cellar: :any, sonoma:        "0c5f839f9f0a31831648c1daaffc71ce2ccd6d47ac62ed1a43a889807c473e33"
    sha256 cellar: :any, arm64_linux:   "59a1e77598d9bb9edfd5b3dda34691e5c4956777e67489c108f0e6025090cf58"
    sha256 cellar: :any, x86_64_linux:  "ade93a27bc5277cd4ac42fd1487bd36d208a508ef46a096a0814d4966adfa51a"
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