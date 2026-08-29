class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.15.2/pup_1.15.2_source.tar.gz"
  sha256 "224bf7d9053deb421739ea16b8c716943db249bcc2d8bc8986cb5a66131d5a21"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2f902759af63303fd8576d4baf0fa9acc66c9ec6627db356f5debdd59ff97db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1164ae52276266205fb14493711b4787ae31c332dedc6ce9c0f99cc32fca5a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e225bee96319f15ce0d8113cf4733dd83db886da15471edf0901e6730d9691d"
    sha256 cellar: :any,                 arm64_linux:   "8bb7bbf51a7f497ecf5be2277bd70ed16128131977f65cce57ed406cd3162a0f"
    sha256 cellar: :any,                 x86_64_linux:  "8abe3bc72bc5912ff612aedf03126e428ad14896b7acf10f47509f0afc78ea69"
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