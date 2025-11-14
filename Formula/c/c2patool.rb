class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.3.tar.gz"
  sha256 "08d29be51e4fec33bfeb5e46eec8df47dbd1f961c8f03bc80bf4d98b8b7a9855"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5bd319646e59e3298f063f24e0b2792ca680a96aea56c5f20588e312f3ee52b2"
    sha256 cellar: :any,                 arm64_sequoia: "cb1a8bf8505b2f7c3cf29fed57d2459c441cd5c53e00798960d76165c7885927"
    sha256 cellar: :any,                 arm64_sonoma:  "45233a779b04be6753f1c05a6bb2e6d78f64c2c765a32a2c953aeb2e59760f18"
    sha256 cellar: :any,                 sonoma:        "8cdcc870098a8ac5b7e40bf41b35ffb0ab8f0ce205d8dd1fe3512e189f773b6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f93041cfe431155985384add07ebb67a90e0c2cffd25bbff1519d3979b9bcc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5addee528c6959f797fe5f02eaf7625d073262fd7c1d7475ea74fe312fd07820"
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