class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v0.5.0.tar.gz"
  sha256 "ec24a63964b01dadf8a29de4656110a976344aa44b0e9b5fee135b9115da2c89"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b84b88d5bfeb5c74828ad7494cd0b9d0b33b83483b766b9b0426c35c4af5a7cf"
    sha256 cellar: :any, arm64_sequoia: "80194bad83b36924bd7df9607c94eaf9375a9d8b9e5375bf3f3e49351426726e"
    sha256 cellar: :any, arm64_sonoma:  "bf4e80ec8bd0ad7bd9696dae16d9cf32bbcf711cda31cc94d9f940ae3154cb5d"
    sha256 cellar: :any, sonoma:        "1c08ae706d41f94f766aba7b9bf7cb2de77bb8a6fb03cdb2a24f67ca71d0d340"
    sha256 cellar: :any, arm64_linux:   "d7eeef78c02ed7eb2e9054bd7a52d9a3852127b10a43be567f201c8b5ebf1a5a"
    sha256 cellar: :any, x86_64_linux:  "10fc2a22307fb058743c9afa18c5670b728e0d65e42cba645e293e0e7d7a6ad5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end