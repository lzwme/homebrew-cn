class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "90a201792a0f65c59d850fdae5af45a7f8c48d3e1ef78a39678afebfcbc2b091"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34d725829be6c3ab2bfd457a9ba4d650f378b19d2517bfa6ffd205974fed81df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f02b7bb70824276969f3b6d312e852b71c8e8a83e7280f429f1687fca30cfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c2e91467418b550de178b631fcc55bd4752f3ae37bb5660784eda72afd6c81b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5268c212841778d2e415dc3ac30114803c6a0b6b809328fccdb32cf9b3f4eb1b"
    sha256 cellar: :any,                 arm64_linux:   "e55d890ac05870316243946dfb92561638637caa6572d3616379cfb56a2c854a"
    sha256 cellar: :any,                 x86_64_linux:  "8ac865389c0299dad76619181075dcf71023ca2a0281c71b94ef76a6f0080c55"
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