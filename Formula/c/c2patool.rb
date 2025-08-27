class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.20.2.tar.gz"
  sha256 "e9a284d712fd9579bc06acde8ae5f4caa4f266b0e286a8ee98764cf94d584cb3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b3074a421d60c61e92f8f0c407b38a775a48000006edfc8cb9e024b8e6194fae"
    sha256 cellar: :any,                 arm64_sonoma:  "caca03c0b75527522a27175c5db2077cff60e7b09da176f7c28854b4dbe85be6"
    sha256 cellar: :any,                 arm64_ventura: "cd7ba6051920c185d48eb4523f4a38d20edf2efc65eea620ae04b65679df614c"
    sha256 cellar: :any,                 sonoma:        "b00a86a5d2ca24b97c178308474ece168b578f06df79ec8a61346efc31b6e4ce"
    sha256 cellar: :any,                 ventura:       "e707311bf21a3ab26be203ec8937d03236699dceade1c81cc1e61f3430487639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d02fb940fad765c93b3ffa392f75c2d55f6194d8aa95a4f30c18df0566bc125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ece49c9491590e7f2a45a6e84bb60bc01b1b63944e753d0316f4867546d206a"
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