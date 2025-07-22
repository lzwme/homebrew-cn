class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.19.1.tar.gz"
  sha256 "53f5b32f316ed1d04a1b63b0c7221a85166b04c3e8adeb30712aee88cbe4b7eb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87eee88cf29e1e841f128926b54d91fa355608c8efef12354b54f3000cc25fd6"
    sha256 cellar: :any,                 arm64_sonoma:  "27f864dd3ff4b92c84b4f18752f9863ebd6b56bb63615050c8cf678fbecb7d89"
    sha256 cellar: :any,                 arm64_ventura: "45d7f0dec9acf697ee8c685c34fd7328ddde75d5090d09bd7e267fd7d8b8b432"
    sha256 cellar: :any,                 sonoma:        "8cb339078e6687af7800e629dcec44ebdeadf363c5bf9bd81e951c85eedd32fb"
    sha256 cellar: :any,                 ventura:       "ddb917c17495ea473704fe06d6191a69726254099f086a458832d4adcec95700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03baef8fa0510dd8ee5a3c7e923112e83872f6d1aa85d73ebc557f4209c39310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad59e52e706440f175e89609bdfd74983f68eb4078190ae87894f8a59d5c936f"
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