class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.8.tar.gz"
  sha256 "c188d9870155c1bb63bd34941fdda6d17a81f4e0325fe11e546bde6e08645331"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efac9f35deae8c8c82b8951fcd7e05d8f95a26337b1b417f23bbd4957152c008"
    sha256 cellar: :any,                 arm64_sequoia: "045d301112ab2c7b6fa5f6de4441f56ed75118d4bb7c5a58ad6ea1aeed09ef01"
    sha256 cellar: :any,                 arm64_sonoma:  "f929f7e3be5a4d9df5c93a6bf681b8ce88f587fc4887845709fda7701b54b0fe"
    sha256 cellar: :any,                 sonoma:        "89543d47831c894564b5b85a651d809f138fbdcdaee14bde6cbc3788466f9d84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d752d032d49c2b24fb0d1892e4e04384d49a2f403dea29a93bab12b3b3f1c339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61e51210b7e9f1df4a9cd0b4417878506fbb37f061a410dd2a279bf8b38c24e"
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