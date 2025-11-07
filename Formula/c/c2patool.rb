class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.0.tar.gz"
  sha256 "22e39e17994e380f0271cc5b1965e6e41d6d4a01445049fc74ca111cea922ed4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dce6b79ab3e9db4ede65e97af477fc795bf369a8c8e35db4fbc9e144dd473ff8"
    sha256 cellar: :any,                 arm64_sequoia: "3eef19ba6ca37ff6eb59f00e7ee19d787d013656168f4e2d4ecf2605354cd708"
    sha256 cellar: :any,                 arm64_sonoma:  "f89378f16cc0fe559f88be358e9f1ef21c4c6870b4cceaec69be59d5af7a7465"
    sha256 cellar: :any,                 sonoma:        "5a6b7ddbb5e9da668955fb4e2e4e892c19f4f5cc2d2ee64de8c64628f98f4d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d2fb3e8a6051c8f4c50ba5c24d9c40791c8bd8138d8ffca90b5642766d6a5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "465bbd1aa52577981dd8a07ee5f8eda3abf5fb63eeed0c7bb7bb1a0e6c2a6409"
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