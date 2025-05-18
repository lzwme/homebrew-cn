class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.17.0.tar.gz"
  sha256 "b4f74332aa31cfe4ba45e272cad4bb500d71d70b4c46278d8c224d1fd6ef60cb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1b1a05f9ca8e1af066eb3c61e446a836d4ffd7fa190453322dd68920ab0a040"
    sha256 cellar: :any,                 arm64_sonoma:  "585881c24f2df31a75f8c104e17b37fb1530d0ce3122b9e3f4c82930d689f64e"
    sha256 cellar: :any,                 arm64_ventura: "376ea0c6cf302197b06dcc1dec80ac93b8ceb30f7ddcab2c7e047b610263270b"
    sha256 cellar: :any,                 sonoma:        "281cb06452d5aa258e6ef6185a12915900f874abd34d2926ab182ebedb524338"
    sha256 cellar: :any,                 ventura:       "a82a48feb34bd781c46b14f294f8b65cbdc5ec765baf6abdab008f19fafca599"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a69bc23fbee9ae5596de459a5e713f14f975fa034b4d8f0ec12c4e674194588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c51a8b50c55e4b27057e141be640cfa671aebf864b59abb8b3b5cbb0caeb07"
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