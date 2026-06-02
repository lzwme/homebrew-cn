class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.61.tar.gz"
  sha256 "4023c5ae77902e6de6bac9e8dbf31dbdd8b622e130a9d7830be84dd82b798def"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e94d73b51d59db7148aa1250485f84b18bd4eb9347d4701b5ba44913cdfa9fe"
    sha256 cellar: :any, arm64_sequoia: "398841aa5d49a97a7402fc96970e73227a76a502717574daadbea73f1a9e7c08"
    sha256 cellar: :any, arm64_sonoma:  "e2b0b78b8967c8ec7f942bf4562aaa7c957381d50aef3894e2964c3dd87c074c"
    sha256 cellar: :any, sonoma:        "25215826c95591367d17f720ad4385eaeb95e6b1111f5ae09c381cfa076b0e44"
    sha256 cellar: :any, arm64_linux:   "93f3cc89303a053fbbf459764155ea9e98c36ba2beebfd2bf5c248bf0c44a435"
    sha256 cellar: :any, x86_64_linux:  "7097aacacf9b7acd484115acba747ae049cd2406eb038157e64d3aa1b2bff216"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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