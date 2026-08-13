class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.10.7/pup_1.10.7_source.tar.gz"
  sha256 "cac684d26df557774bc6e4e8ac104b21a4c00e9b25023b2578059438963788ae"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be12988fa6b9d4464ff6c2a217aee5f4e986bbc099e1b99cdde5740ee2db0364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f89abc55538aebfd8a85d844b10fc10ab4c1d8452645c5c31384748c7ec2ddb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5a8d333ff6418dbfe2da2031bcb8f86f3ca9057e885905471af20718fbc917"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de1c8c12fb986540960fe9dbb71454c1ea497c76aba749f4e29070343723eb0"
    sha256 cellar: :any,                 arm64_linux:   "b2681da52e6058cd94c57ecbc18b00ccfbbcd0ade7e3ac354459e499efce7db8"
    sha256 cellar: :any,                 x86_64_linux:  "b7e1e4a91f7b9b5f058fe6af929a2c2ab1794988a6c895cdb0130a2831741db6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end