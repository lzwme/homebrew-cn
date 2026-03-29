class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.42.tar.gz"
  sha256 "54f9032ab779942032ddcc37a6108afc24daff19bfca0a19d9af184fade8d4ec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43f14d7ae57aedbaf7baa62749ba9293b88b0ba934c54e3385e4c75d1a8f7bda"
    sha256 cellar: :any,                 arm64_sequoia: "0b12e5f61530750a7d0148a23dd61702df61424df81e71ef915c007422f34bce"
    sha256 cellar: :any,                 arm64_sonoma:  "1dfdaa38b737fd93c95426c7211dca0f4f288b0ca324bb0374f27c2316200bc1"
    sha256 cellar: :any,                 sonoma:        "686331d42b017c78062f050564c2ab2eb99c14acf8835458277c307e518050c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12333e44e624fe5cfc04d6131fed646494b2a41b3527af9a93ca4780e145a38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cea985b0b74757fe3bf16f494143bf7eba70efb4088109fe2f2a48d34df84436"
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