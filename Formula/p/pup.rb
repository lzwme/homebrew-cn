class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.20.0/pup_1.20.0_source.tar.gz"
  sha256 "7e7e1f2c3640457132e8f75e74d822a9dd97dc96774ca433af314d9aaca82562"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd5f90720caaa279846a6e26ce41abe3978a81baa01cf877df041d8b51f590b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b5050e14e253d5a3b95acfc1e2c96effcf656e228031f584f1162bbf8bd8138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f074c209c87c40071400038441accd1bb4351d7ab4eba4b8c97c3b3ba004089b"
    sha256 cellar: :any,                 arm64_linux:       "bd538c448bb4718c335034e93cdcb1fd44b7d3df3104017c0daab75e53405964"
    sha256 cellar: :any,                 x86_64_linux:      "770019299cd38a741cd43fbe355948ae9ae2ac5c711dbb4f475ec76e96c9b143"
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