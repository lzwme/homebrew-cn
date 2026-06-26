class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "dbbf002e661819ccbba538e449a78f08ac4e6c0b519233d0fde59f9cc2aac2df"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5d3a26ae8c4129af35cead523050d0b6c50034020a2877e8318408492b9d9e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "255cc44b48209199a8e69cfdf2f0f2f905a5fac0dde6fe2712e10c5657d5f8ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12c690b68a00722d6d6011d7ef56055f5bd1fb0979a0ef07fa2ee3edd2c9a8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d294dcbacfb016702a1a4107048f179f5b49906474f7f5960b439ea94030b265"
    sha256 cellar: :any,                 arm64_linux:   "3d59a9aad6e7ea5f7e228938ca8b4c3cca603a4b3be67596ac67e503f8916064"
    sha256 cellar: :any,                 x86_64_linux:  "cedde5ee556aa18c75128127f6916e7de8ddc6a445f739b41d7d4f4310bebcce"
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