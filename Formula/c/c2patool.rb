class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.43.tar.gz"
  sha256 "2a14e4ad67e51c025a7b54fa6837e2a4b9523c582d37d5600cd0166844fbb984"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6284f17219dcbfcc6e68290a0e9a63e37e9482ef41c724cd8dad340c59ac536"
    sha256 cellar: :any,                 arm64_sequoia: "8fe62f685977cc5ec0416ade7cca63daa3fc68971f62d3ffb0d386b41643d9d9"
    sha256 cellar: :any,                 arm64_sonoma:  "41b5ab496bf2503fcff142c5d914699c61bf1dbbf596ff9605e15e1e372f7ca4"
    sha256 cellar: :any,                 sonoma:        "320861fc3ca9e258d1fcb771dc82ca497e0d593b3441bd88655ecbd2622f3b09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb3429683db97ac293248861aa8eaaeb49ffde05ee7a8fc2aebc28742487382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83cf9e84ca9832da049c7b3bceeaec62404e4a3b63e868c15838d1332293efd9"
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