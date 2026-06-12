class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.67.tar.gz"
  sha256 "392389af2f2af57b44a6bc433453f35ee9fdce6e62c450fd54d9f29c8650c725"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b8dac9e524bd7deab8c021f9d2dd9464adaf4656b706b33d0103cb5d99e1f2d3"
    sha256 cellar: :any, arm64_sequoia: "f955ab5273b55e252c43d51599332d5241b82a6e1f7197bb728cc23ce11c1c1f"
    sha256 cellar: :any, arm64_sonoma:  "a9c98287165c0ada6db76b6278ae3a8e8c2e4cdc2a27296830343ce3935d4c38"
    sha256 cellar: :any, sonoma:        "4e377a9eb8f2e0ca88afeea4b06b0c1e9a7eb14c6304dbd66cc1d33617147fd9"
    sha256 cellar: :any, arm64_linux:   "19d8b3f242be20adbe2137abc8bd5742a2c32cb9d70052a3a682071eac224c2b"
    sha256 cellar: :any, x86_64_linux:  "0f63895b2d0397cd42f78810a2cf484a7eb0f20810d9e8ccab7703d5e44f76da"
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