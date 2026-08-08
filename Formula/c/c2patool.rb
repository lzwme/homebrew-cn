class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.7.tar.gz"
  sha256 "5a516d48eede79e68da682f8f2ec6ce46f38426cbd12ecc5d56d498bbf4c1e38"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e51a59e9695d6b3dd4b4775bdccc404cad357c6aa212197986840e65c20b413"
    sha256 cellar: :any, arm64_sequoia: "cc06dafa18e210063ca59ce18ab6aabcc1739f5599aec8883622a3d975edbab7"
    sha256 cellar: :any, arm64_sonoma:  "c390371680a87b6dcf52ebadbef57cb982b8ba16773b5ad423b13bfaa0a4ff4d"
    sha256 cellar: :any, sonoma:        "4e38356b65093c9527dd93e8ef1bc0e4ec347606fa790baca1f8e449e80b5c8c"
    sha256 cellar: :any, arm64_linux:   "0ff3177dc4274947fce12c559250af37b29cb60a1c78e2695c515f4d5c6b5088"
    sha256 cellar: :any, x86_64_linux:  "465e959a14c42759b78c52877bcc3be15e7fbfb30b9a5af57fd8170704a3f2d9"
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