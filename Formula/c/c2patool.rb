class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.14.tar.gz"
  sha256 "dca0309843e44d0e7e4a4cea257d34dec37837c7d6e89e1059547c491086cdd1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f092b9cab54027d821ad9ec109aa9c4732451cd3b99b16d4907a5ff353c60eef"
    sha256 cellar: :any,                 arm64_sequoia: "3082f55f6b6dd83c1091f6ccc3985d26d89ba9ce1537964c060191c088bb28ea"
    sha256 cellar: :any,                 arm64_sonoma:  "3eed3737f0b4fbc7f7de2c79527118c8f6c080f722cc70c73e19ddc135edb7cf"
    sha256 cellar: :any,                 sonoma:        "7b670e0ae5b42d79c23925fb5f304ce331789a61cb072bbb2ba472ee0912a0f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38e9dbed10742153df765d0c7415efa95a16fb879ef71e15a31b75439fdecddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7bf3e2a99182c60e7e455f2d6612ec9c16c3fdca8f0e1675feb4fe42c457b3d"
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