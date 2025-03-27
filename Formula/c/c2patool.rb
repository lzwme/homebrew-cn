class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.16.1.tar.gz"
  sha256 "b608925137af9b372f76b52062f9d59d2b630b25b48279b3f4f905de4e6f44cb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5807c04c9229e70a2a67791c42e506686ad65ff407095a16b4377114e714b67"
    sha256 cellar: :any,                 arm64_sonoma:  "936d848da3a24ee1505947de45fc8e076dcee833e40e023504e752c99b4c855b"
    sha256 cellar: :any,                 arm64_ventura: "7a436fa2042b20b333cb06d11f400cbac1b963f9f096f905ad844269e4f37bbc"
    sha256 cellar: :any,                 sonoma:        "98018d7cf1b788b56d8f7626506bd1e62a337c1ce25d1f14c8b3d8d61334a803"
    sha256 cellar: :any,                 ventura:       "7df6b27be9a890cc297360bba084b0b2f91fdddcff1f3e967913cc706881581f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd0d80246e934682eccf68c49ad4881e0081ca9b817c7fc514ecf69385b851b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8429d0e1098962f04a67f915a76451a34c74c1127a754fb532ec55979718ea34"
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