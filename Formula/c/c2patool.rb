class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.40.tar.gz"
  sha256 "899dcaf58dd1baadd023671a6c6c5105fcccd054396148b8552b005912f2f48d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87f30d6a93609aace9da5f58f54d7c831bbadec5d882093b1acdd904071b013c"
    sha256 cellar: :any,                 arm64_sequoia: "fb1762339584c2cdccc4d2401b7ebfa976e32cbd65aa36132ee62a492bb9c285"
    sha256 cellar: :any,                 arm64_sonoma:  "9ade894fa52e634178205e77716a3125257030ab902ec52ea2decc21d18896c8"
    sha256 cellar: :any,                 sonoma:        "7e63909d110a75f7cb7dd80216599b8d3aa5aeedfbe10b56c23f6c5df8d92c7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245c51cc7d2e8ffbb86bdff8eddb557ce5fd4d0eee471e9a1ca955a555d46b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3bd3ab232527cfab999062b03b9c744de28b56d8d275613440814b3d0791ceb"
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