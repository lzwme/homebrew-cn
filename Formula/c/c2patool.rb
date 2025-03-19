class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.15.0.tar.gz"
  sha256 "325550d1c9096498528d2c1a170952e855455036f6624030bf867bbde8936d2d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab1caeb14c7a6eee5a76d0c9241469f06a1c1fa71afe44c5062431f5d1818166"
    sha256 cellar: :any,                 arm64_sonoma:  "6f260022bec47ecc322f171f6511190d8e90ef7dad2e838ba6b0a1edb6f08de8"
    sha256 cellar: :any,                 arm64_ventura: "793b742a2dbdd40d0d55b856dbb07bf518c77179f7d891da1605c926dedc4af9"
    sha256 cellar: :any,                 sonoma:        "95df242ebd295988d5ff08c22c0628fbe2aba6ec2e81d1ac3f0997b39d00228a"
    sha256 cellar: :any,                 ventura:       "4800479334fd73085d2244f22d80a779f4ea0d13acf08c53ed4fd04489ecde31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea75f6a018c552bd860161cf6196c6584f184f519fa1182437444a409f18602"
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