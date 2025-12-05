class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.6.tar.gz"
  sha256 "9a24e4c96a896fd5c42c391f7402af7d52a98b26bb1e0bf9c96f444496226593"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1c534474d598c12d001ea5d0b3b1a282c87e6dc5aa281a63eb4ab07dfb8b26be"
    sha256 cellar: :any,                 arm64_sequoia: "4f839c1b2e1628b51620cce55603efdfafd06e4eb0e634a3e243db4852510e41"
    sha256 cellar: :any,                 arm64_sonoma:  "7f7c16f0f3e477f432f956f3d08fdaecaa3e9af1d5d8dabe09fe52355bf93457"
    sha256 cellar: :any,                 sonoma:        "e614083b0157fba25359fa853293e17624c34e27cb22e21579520d73bcba46a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88b256308846c09a8d40d281734edf13296cd67861590b54bf236346568cb175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02f6bb1bb196dad4b218243df79ee9f8bc693af855cf6e61949ee8a6f581232a"
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