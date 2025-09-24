class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.23.1.tar.gz"
  sha256 "cf95dc40218dfec0f9df8c6a446f772ae590fdbb9531fbf091b18b9a8e3f7004"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36202076a6d3cf6564d2dce4ef519a4f2bca9e94e579a880701acbe9b2a4ab37"
    sha256 cellar: :any,                 arm64_sequoia: "5bec8e2a7665e62169bb4fa116ab01b3f70c677d5942d5413a95514ad8032c38"
    sha256 cellar: :any,                 arm64_sonoma:  "ae6dca57131da9c4e22f50fc6ec153052e3b27b042824f6a0af52a1f0be350e7"
    sha256 cellar: :any,                 sonoma:        "901fe2b24b23c98081c2ab4a9a44012c3bb884a4d69d74fcd6c11c08bb8bb099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a402a98a98cb9f19e3f9457c781f5722404dcc1c3fd169237414ef3724412a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f7b58ba022bf4b47c75a8e1443277ffdcc2a2a17b216d6560df3c89d1265a9"
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