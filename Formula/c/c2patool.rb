class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.20.tar.gz"
  sha256 "52b882a27391111a83c1acc04c81c78e45f71677f7e9111bf9b69c86fde53397"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b4a3f28686b4f3180400dc298d1880102b3e4049b48e899eeaf9c605f16d5d2"
    sha256 cellar: :any,                 arm64_sequoia: "40ea62663e3fb390faed5049ef904b8578ac154301e034463be74917c05eeac9"
    sha256 cellar: :any,                 arm64_sonoma:  "65137752f7b80b28eb29074c273bc5365245395eede513f13ff7d6b54f852c33"
    sha256 cellar: :any,                 sonoma:        "e8fcb188d534e271c4521d126e023639e4b4d66c6ac028f2cd0c4c5ffa62e0c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b951f8d4c064af925a8f2d92252e695d2cd49992dad8a873946241ff1406895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1713856342e426e43732f9933a1f18eb5ca1d1cc70bafed6c07179ad3db5303c"
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