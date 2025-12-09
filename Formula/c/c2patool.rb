class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.7.tar.gz"
  sha256 "95ee8aac2d1b6026d5064183cfc5f359b683494f712e4260c251a9f0764db62f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0cbeaecb51619d63528f15d8f77cc909964e953984bdb0005dda780801e476a6"
    sha256 cellar: :any,                 arm64_sequoia: "eb6d7193697aaf16735c6f2dd27f8d76aa9b7669f14b22498541331ecfc30de1"
    sha256 cellar: :any,                 arm64_sonoma:  "d0cc1aabff03cf22f7391badfd4a5bae200b9f68031e75cc201682e72dd1c917"
    sha256 cellar: :any,                 sonoma:        "418da255afa7857d619cbc464ad764daff409739a03fb939aab3ee00ddfafd28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a58fe9b86ac7a472282ef5a6cb91ccddf0e1053e5c15df6c8a5ca02b05e8d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4ea705945d89997aaa401361597bad76db37b7b06cb7f73c1620dd0092f0b3"
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