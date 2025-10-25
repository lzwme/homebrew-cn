class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.24.0.tar.gz"
  sha256 "227a4e3b2a21bf90c6696d0b557e04c6ecfd93aab3c7c7104490ca13a56585f9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "083fb4728682fc44354c6526cfd30ca1e8f2f43c74a640186d0ededc2f3ead6f"
    sha256 cellar: :any,                 arm64_sequoia: "740a22ec2d358bbfcbff4cd9988d33cf806623c0cc5c9d2b09f5fa3dd7ed4b27"
    sha256 cellar: :any,                 arm64_sonoma:  "f5b2008492c275aa784187a2517fcb328547722789f53092d2aef39ef1aca505"
    sha256 cellar: :any,                 sonoma:        "13c744d5e010afb3fc20f37e17575836d33e22ab3d14a2d6c3d8dc0940492f47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ac6df8ab6220c938498c1cc083a1b9a6268a9677c14c9829193aa53c821c55b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42bcabe3893755127464e157ab1103c862ec8874b0647c50c2de03a861a5ff53"
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