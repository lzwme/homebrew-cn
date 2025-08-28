class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.20.3.tar.gz"
  sha256 "2c50dbf4a2d6d230cc2a3f40f170e085706e4f1b9c3d3688afc4f3dd12477d9e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9e41599c92731a22c09e74bce63b4d9b1779339207732be6aff4114cf36ed52"
    sha256 cellar: :any,                 arm64_sonoma:  "143bb58dac84dffa492c8a015a8413cb1f4ad73568b547b40442b58fb766f9ca"
    sha256 cellar: :any,                 arm64_ventura: "3f48c11d5290102311490e6adaeded0877256f00b6ef5096fbe59a19c2302efa"
    sha256 cellar: :any,                 sonoma:        "5427c62d0ac1aa9d33207b9512d884cbd750268aa574a8cc9a1b3b0f111694b5"
    sha256 cellar: :any,                 ventura:       "7f0531bf5692bcd62bd947a6f3b4f344fca150bd46aa4af7d990b5ce0e8595d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060d94573d7b779511188fa6f2de4d04beaf3b203f2fa0f2eb40275040892a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3b77ea5960e4c95ad00d4050e0fd7d0fb32a3e14571265c6ab711b7b64a5895"
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