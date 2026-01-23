class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.17.tar.gz"
  sha256 "e40dfae931898332a61c33476747d64d83443c7d6f14bd4ad2d7803c0d49fd47"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "268628f159da99409207f4720147d521e1d189ec77aeceaa5c98906d85e8cb4a"
    sha256 cellar: :any,                 arm64_sequoia: "1431d066eed8e1afe169d746f32db900b2a3d08f800f16c6146a74f8fcf0b1c0"
    sha256 cellar: :any,                 arm64_sonoma:  "cb103e61db9957a8d85f00d620e494e4abc757a87d61df58b5626069eabf54f7"
    sha256 cellar: :any,                 sonoma:        "8aec434eaaf688feadaf15620a2358905182454ffbc45860523550ac68ef5e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bb09a962b5bb899a52e7659dd0f19798bd82b349bf3e6ce3724faf8711b7d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c33d93960a9c9c99607721f6e55a0d3ffc603f2e5ed480738ba54fc59b2e0b2"
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