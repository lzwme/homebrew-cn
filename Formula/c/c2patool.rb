class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.27.tar.gz"
  sha256 "7e21b2178af8ce38720bccbf546b32dfeb25c1457fae6e59570d125e0c92a04c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ffd4632aecfde701a9c0576bea8a275fe0bb3e9a9af35107354819addbe7442d"
    sha256 cellar: :any,                 arm64_sequoia: "d0cc06d1e09d12ecaad837eee888906caff458217e740f24ef0ebe40366197af"
    sha256 cellar: :any,                 arm64_sonoma:  "b6cb266d402ed05f010434d797f8489bd6246150cb8b4c6f25a456b6a1932da9"
    sha256 cellar: :any,                 sonoma:        "2352fc0a29d7c88b176eb569dedbeb72d06454d08d4f02d9f191cd19c3751ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41f19c455cfbb9594e8a597334af683b77bbaf35db79c20cae83977ecf93c79b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b218db05ff0c77872b558aeada90c8b894163dc0511bc12320d7071cc102c05c"
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