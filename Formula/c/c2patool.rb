class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.16.0.tar.gz"
  sha256 "61dd341e60fecd70d116aea87fde598dcde99f5eb337c0d4e856884982573028"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "942d70c9f93d3cfc9d1daf340da15201537609d7e1f7318a752e65e043055518"
    sha256 cellar: :any,                 arm64_sonoma:  "ffa43760272188e8977562adac2f553ce49de29788e62f097532132245737e90"
    sha256 cellar: :any,                 arm64_ventura: "1d7da7197d20fd191c69d0970b0b7f8d283e65b649f60ebe2f1d3abd71afd022"
    sha256 cellar: :any,                 sonoma:        "26d83ee3944eb50a382cd66b39b3368976d147c59c0dd52a82ddd3330a589a53"
    sha256 cellar: :any,                 ventura:       "a986c704914b5994c26f2f9441d8494f87652c7963c23ce1ac01a406fcc08d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "912e858c298158b49c46cddcbbfee892dea8491256360dd8a02d264430f0c31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33668ea7d76932bb368c09351d80429a06a626cfb475b95d194aecf6800447ee"
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