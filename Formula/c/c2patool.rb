class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.20.0.tar.gz"
  sha256 "eb2ac210e0e49d9f53d8aeab05146898314e5ccfaeaa9eeb1b814e93b22dd8e9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4348688ab59ec7287ea6a819746a2fc61ac8c3950540c836781fbb5dce61f574"
    sha256 cellar: :any,                 arm64_sonoma:  "dea0d6c52f7f0c7384fbb82d2d5be3e4535bddeec39646bdd7a851f588f66c98"
    sha256 cellar: :any,                 arm64_ventura: "52546164c8faa4d372fc9c640455898c0fefc64b7b197bc127ba7e202f1a218a"
    sha256 cellar: :any,                 sonoma:        "ccc2f4032537e31d2e72dca467882875b170e6cbab1d25b8ab032259773f7324"
    sha256 cellar: :any,                 ventura:       "2a945b21a8595efb1fd0b62d70aedc250ed73260d2e36d058de9465a1a074b32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f1241000e5b84108532017d89604ed4baeb278f71015e12b4682656837f68be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d02115c834958a202f0d65b84006b7565f4b518097c0dd3ddb4306ce19637252"
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