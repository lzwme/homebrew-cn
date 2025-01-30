class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.13.0.tar.gz"
  sha256 "c2e952cec5cb50134a33298863d726db34f43f3abc34a1bd9878a86d59b6952d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00e44df273b434c85abbac3065eee6f4bf1c4d824365bd701c04ee97b9358640"
    sha256 cellar: :any,                 arm64_sonoma:  "694e9ae71aa22d5ce28edfef9d9c52081b963a68b735791b53b7a18f1e303e33"
    sha256 cellar: :any,                 arm64_ventura: "3b8a06f938d49043493feb87c9bb5bf694521434a838dc5b1092fe93ae443392"
    sha256 cellar: :any,                 sonoma:        "edb0e52cf53bcc9c0c203613a7f074cb6be881489d4cc57c842d596260808d0f"
    sha256 cellar: :any,                 ventura:       "67db8d776f870f17112cc1269ec8dde44887b4821c1f0d8cf1b26d650e44e1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35e2fc949f0b01083ebdf81fa77200bfa19782988caf0bf4efff60d1cd3e9da"
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