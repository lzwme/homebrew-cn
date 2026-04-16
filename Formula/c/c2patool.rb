class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.49.tar.gz"
  sha256 "d540d4ce2ee95d802fba68111ca775d272bc30e189efff74b3c69dcf27ca1ef2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5241329c876e7488af41faf5da32867696393236a1f7ff7b9e1369bbc70a3f00"
    sha256 cellar: :any,                 arm64_sequoia: "3afb4c1e86fc876fbb3bc0a0530b3a28cfef63d6590b7e5db31ac240f11d05f1"
    sha256 cellar: :any,                 arm64_sonoma:  "f8fa68bd20143afae1fb54139589d7d715ac5944b199b7d85dc149b6b8c6a18b"
    sha256 cellar: :any,                 sonoma:        "f656422ec8454041953302820e76cf6ace02875f704ad1ea5200fa63e489b71c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b4ee12279595f9c6102520a1f9837d19e1abcbcd6dc0ab70389454573aafed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd0429d02ef151a200a5c6d97b24727df04ecc49efe8c2c7cddbd8fb95f5f3e"
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