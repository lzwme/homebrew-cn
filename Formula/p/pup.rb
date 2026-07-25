class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "0db11e60a3c14a79619e5a32e4030fd73330f8507987d1cfcaad931b8d39c811"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64ec8f9a346f12e18f4988a4939ffc7ee98182fd3a92473a97b4a9e6f8460ad2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "439b67274e25754669fe43915e022e37cc5bbd1a2d4cdf9565678ff89599eaf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f231301918f8e5216664b89156f20e599f8454c0965a1bfdb0b0b4d5cc5f45e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0831bd1f1297366d92e29a2bdcf155d67155148138d3bdddcc5f4db66f2771c"
    sha256 cellar: :any,                 arm64_linux:   "979bd9a91df9003c35181071d37b0a9ef2f44df98064606543527192589f45e8"
    sha256 cellar: :any,                 x86_64_linux:  "6b98a1726c8151ce4f75fd67e555fd407de4c6d4f8c0cca52f6622f6b9d225ec"
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