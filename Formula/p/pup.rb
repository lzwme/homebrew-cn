class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "664a389903a6cfe46211b3dca20c556564aa555d687d5aae2421aec5e109f797"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cc4464e15a6055b3f2d4baebaf1551f1160cd301cf98c3009a9b96d5bb36a49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca33325391c60b1ce6d7d5e9ac1f86d02dca0cb90a064ef5b4566072fb4ea07b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a48277d54a448d13c38f15044f6e5120988ac3d7b991715f68cfda02bc9ec85f"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7a59e89c49115bb7890911aea50bbe06872de3f9f327cc6ab0ffe68b063111"
    sha256 cellar: :any,                 arm64_linux:   "c56d01342474f6f54aae91fcc8f1b28455e29ebd40703ee6683cc09bedbc67a1"
    sha256 cellar: :any,                 x86_64_linux:  "51a89de198fb0da6f8ec76ca4e76900a2e8e3b75e5dc477ac4870fd3f7475e5b"
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