class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.53.tar.gz"
  sha256 "2f64a1a349c71454e30dc073ad88d2dfe27e123e5c74ac9d3583c0e9d68c5550"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be6c9c41318771f7df9445d11583f821ac830142cde2526bdb138143c64364cd"
    sha256 cellar: :any,                 arm64_sequoia: "1ee4cfc038d1598782c8ceac2054c53b0bf889865d7e22bb7680b4eb50fc7698"
    sha256 cellar: :any,                 arm64_sonoma:  "1f3dbb0555b92df2935cac9bd3c5d7e1dfbee6789459845964950c6a185a95cd"
    sha256 cellar: :any,                 sonoma:        "59f333caa7be17c6c5d97c206574c21d968d6b29a68b4650ff9655f3f12ee20b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "308dc79777c95cf518c759b1219789c6f8d2d186c34f4db629192b852504c7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03665301101f3e76664e53b0d0eba9cdc26336903f33927c57edfe5ebf4cb0a6"
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