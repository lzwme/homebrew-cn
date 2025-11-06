class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.25.0.tar.gz"
  sha256 "0dc37ff2340121b11d319088ec1fa245d23ab4716669f157e245ad90762e4e51"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7ca7941ea29ab3df2a6947d598fa41f0ee8214afff548365f51d7aa3475d718"
    sha256 cellar: :any,                 arm64_sequoia: "a08d16b7dbc19df72d7230bc9714f00750998ba2076999b01578e98a0a8f6b90"
    sha256 cellar: :any,                 arm64_sonoma:  "4ccf874fca304f20768710b2f29b3bc02a2ca6385fd0d3feca6ef87b1560cb26"
    sha256 cellar: :any,                 sonoma:        "0d15793df50b189968fe41f35f82ff0386903db6198949a424de1f6af6774fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6ebe145383d74e7fd111484a802f5fed05cbc64c5a22752d5e3255b6fd609b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b1d8c822156a1e349bc407554cd2d5f0e976954a7cee95c4df0773ed5675868"
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