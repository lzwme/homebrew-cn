class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.10.tar.gz"
  sha256 "5588f86edfc06dfd44514ac254a9e202fde6d304c2a2e797b501d3bb9797cba0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8428479a4fd9f492e48356aa3694de6ff2a4afb469cd7f7e04ada75ea6c56e51"
    sha256 cellar: :any,                 arm64_sequoia: "62e8041fbc67b6c702ea3d9e5464bb3f88b290c038a54dcc5d435ad0d0f62280"
    sha256 cellar: :any,                 arm64_sonoma:  "d53fe63da4fd48a275d6314c3d0505e24a1e8c3081bc126c73ffa8bf29f3a084"
    sha256 cellar: :any,                 sonoma:        "93cf16635f99206ec0ea7ddc22ccc4a3ea02571eb4a5ff6b2cd1f3bc0f59ce33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29a4a30dfaba5dfc279eb0505166703f8e3455f1f0b5ef119839daf39c475c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5eda0c0bbfaf6c3fada8544e4c7edf2f0bf9c955a8789b2b55334d722e937d"
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