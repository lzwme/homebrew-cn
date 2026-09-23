class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.23.1/pup_1.23.1_source.tar.gz"
  sha256 "b3477f78ccee7a08d3e9a5ef65c865aacfa16254fba6a519e18be6712382583d"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dee34315c9dc6418509ed42f3319195d50125aedb30534fdeb99dcbf7ed58f04"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5729e81e3b11ff898c606a1dbb420ea9cf9b4895758520c89744ada098ecb5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf8d492823fb72e1021bc96565a7bf14ca6ecfe18c0eef89a3e482c4c7271a0a"
    sha256 cellar: :any,                 arm64_linux:       "80668641b801e2c98542495f27abdb24550d681075100c35047edad2f5cef4d8"
    sha256 cellar: :any,                 x86_64_linux:      "3edf80685cecfb9450d0a1dc30feae1d8dc76fa99f6e3492bda6f06e1943ffe1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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