class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.13.3.tar.gz"
  sha256 "dd9ca1ad92c8c66fecf1109aafac517391654b923d32136b391ebd1e0fd30cb0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db0c9e2d079d43593f9871726e0a44c45caa6ee12c7b36b9a5378b5ed4a482fc"
    sha256 cellar: :any,                 arm64_sonoma:  "4f6dd52b616a85268366bbcb036748ddb8d0636fa146c2dc422eaeb644ec774c"
    sha256 cellar: :any,                 arm64_ventura: "389e7082d44624c4f67f5a1d4a63ff4fba54b5c5ac5be73eebd9ce169548638f"
    sha256 cellar: :any,                 sonoma:        "ab4083372f16609aaa5a07cd2dab78a515205fa452ee79f4581b08fc69f14d18"
    sha256 cellar: :any,                 ventura:       "50f55dd1f1341aadc2256304e08d8c87238b2f552bebf0a71fcc6b8c8d56c81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0166348b97e49ae5b7e23615da8a184e87f1188f232fd621dfb61a299a13104"
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