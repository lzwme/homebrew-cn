class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.1.tar.gz"
  sha256 "f63ef60d750115bd8adb683a06a7d43a5c7ff540ceb8eb4469ef30fb500f3944"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85ad75bd5fb8e5e1d17cdb1ba080d2b4811e98fa857a8bf8f4d05d9860d9424f"
    sha256 cellar: :any,                 arm64_sequoia: "02b6c955eef61a904e7e6d2f5752a7e4237255d7b5330b4a9e6fd2bade9005a1"
    sha256 cellar: :any,                 arm64_sonoma:  "ad11a1a0b19b10b5a76e10d42e03a68ac9ba68c42a07b537b6ed74b863df9cb1"
    sha256 cellar: :any,                 sonoma:        "5e58613f04c5cea20093173d1fbe77f739680166e25bb643f726f6b2a5de1d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "963816b406394b8841b8cd3b53f9163cbcf542715bcd241c91284b0faf9e88c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311a56ccd557f8f4220c9d3cfd166dd372d42a63409446400d73d857e52b22d5"
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