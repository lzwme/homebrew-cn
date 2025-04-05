class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https:contentauthenticity.org"
  url "https:github.comcontentauthc2pa-rsarchiverefstagsc2patool-v0.16.2.tar.gz"
  sha256 "425498b409a92bf9af9a7c2272af5d2f59e7ab0ee03b13bcc8823379e69e20b1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comcontentauthc2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(^c2patool[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3cc2e4aae3aecfccf61f2a9665a4836897259c4adc6b0ee014596870bb95e73"
    sha256 cellar: :any,                 arm64_sonoma:  "ab93c13513ef049a2b26f0d96e87f587daf72cb652872f34bd57a8533bd1f2e2"
    sha256 cellar: :any,                 arm64_ventura: "b32cb853d1790c82533db2f0bc6ae6e5ba1bd7b4609d596e23e4a3d4cfabfe44"
    sha256 cellar: :any,                 sonoma:        "07011d21a143022cd94d0ccbc4149d67f173d4bff04ec201222569585d20db73"
    sha256 cellar: :any,                 ventura:       "f853d7047dae27e89212fa2ced7af48ae4381f330fa3412125fd7953c1231562"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b85b9891fea717dab540d5fa42efd099ec5cebcedde876c7a27ac5d6cd3cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1a8adf3a3a6e03ecaff5f4b933160355673892511ec9fc370a0c9c793566cbf"
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