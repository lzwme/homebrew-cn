class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.37.tar.gz"
  sha256 "9140c3e0d3d5b4e1d55c3d0e1ebfd56b37ffdb8823e543ce0e4ee6b0dead31ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc4aa3033ef0af448fe8c64f66af71b77fe70438c09c7ef5e7d0d55976f93c32"
    sha256 cellar: :any,                 arm64_sequoia: "3a67fcc67d818e9bf7b0c5f64d77cc2ee65e626225016dee3f50057f9d108625"
    sha256 cellar: :any,                 arm64_sonoma:  "404a8f5b83175de7632524ea393f26b4c1e2ccfcef53a3eb1cfbf4099e4c40e2"
    sha256 cellar: :any,                 sonoma:        "6f9a22b8371d10230bd92c84a5981661cef146e3b6257f77bdf277db8c27868e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6aad7e3a17638ee24949f70b2b79f92fae56479256649ff67ae09356951adad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa6ca2c30466748638f8d13666320ad9f5b346663891fa60041ddf97c5169a15"
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