class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.23.3.tar.gz"
  sha256 "ee543d0ff991baeddaf346e998b4d86b05bf0f64162243dfd713c55c0c236065"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eec804d592d2946453f1386de753323e561485c3ef160f3e68f51efa8cb4f743"
    sha256 cellar: :any,                 arm64_sequoia: "b8f9437a2ce26e7288be9230312e64b50700650c862977d02a9a8733722b480b"
    sha256 cellar: :any,                 arm64_sonoma:  "5910bf7f80793e341983aadd3e5b414542aaadbeb8142d178fe3d7ff879c8398"
    sha256 cellar: :any,                 sonoma:        "bffa1e13ef6e3d1cf56041c2c6596d28e405e0a06605f40d59fed8366baf2db8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c332917834eef89a6e31d6f2ae2dd2a8da3eafb45ab07383859e9a207ef09fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b81e77a0bd6f56e8aedde7a9820fcc0bf07f802edb629bbaa928d1773a979c7c"
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