class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.14.0.tar.gz"
  sha256 "2361259319bf256a073c2e236f2b22fcd7bfc2d01f54d9dcf8de64be59a9db2b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46fec5e32fd741a02f388cc2dfc0607e19afbc07a74285e2f349bd0d1fe37cf9"
    sha256 cellar: :any,                 arm64_sonoma:  "bebd64b46fbf519082c77ea1fa3001b7f4b6a69a18e30fc30ca4b0132415742e"
    sha256 cellar: :any,                 arm64_ventura: "a68dcc831a38b798d12d1d254255802363323f805660a01374ef39ff371891cc"
    sha256 cellar: :any,                 sonoma:        "242c9c3cc8a677d5e97d28e03f6784573445bd5970d5ca7b2a67f268cfd0b839"
    sha256 cellar: :any,                 ventura:       "59b676a8ac18f234a8c6813ded66a21799e9d62166361cd6741867ac653d4607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1102ee325a0adf3c16060a1d41553d63759d5b099d11add5c6a2ac8f1ee17e14"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}c2patool -V").strip

    (testpath"test.json").write <<~JSON
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

    system bin"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end