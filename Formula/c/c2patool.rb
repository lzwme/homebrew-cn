class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.4.tar.gz"
  sha256 "9e5ef887005c921d6477cd247a7b6084650e36880f52ec617772a5018637ea64"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1885a20a956c03bb79079bcca0b4a5fa7917287f0614da54c1f10cac30a30e7c"
    sha256 cellar: :any, arm64_sequoia: "7ba925908093fad380c24bd1d0a2eafb7ead09605f1236e8d57884516cb909d0"
    sha256 cellar: :any, arm64_sonoma:  "45764b7c92268ae19ef94b7ffb8d2c934af8e24b19d9a74c958eb9f188e40b6e"
    sha256 cellar: :any, sonoma:        "0146df59674de9b53f5b7710d870c7f51714fe942462c6cca52878a2dc529748"
    sha256 cellar: :any, arm64_linux:   "6b4a3fd480a160703eea8a28a37284a29457088a67eff444fa728643aa952058"
    sha256 cellar: :any, x86_64_linux:  "c0ddf752779e7a44fc16f15f8c6bcde96102ff8055dc1fe07bed91475b44bf1d"
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