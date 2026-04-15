class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.48.tar.gz"
  sha256 "0f14b245d0c9c568df0ccdd9805f6886f61b6beb5895736fc50147c3c78fd466"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c85eda761643fa6860bf7f19d80cb6320897316a09d2ab32a47a1ab7314f1fc8"
    sha256 cellar: :any,                 arm64_sequoia: "370bf2b0968e53c5b002b16d2ed7e32935caf2ffdefdbfd6009c3b5140a7c58d"
    sha256 cellar: :any,                 arm64_sonoma:  "6b350ffd945c2c80c4b32e0cac122587e71c774e2d2dffcfa40f20fb333c4bff"
    sha256 cellar: :any,                 sonoma:        "66ac106483e115ccc9ccf07275761dd84497b0ce8e83d9912857df69395e4d83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6628ca4c41ebef81e3388c4204553e722ebfaf1959e79c9f1eb44be243050a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11d1a6742fe75be8eb0892a0461a228ee8a4d07b7843467c13ecfedc00408207"
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