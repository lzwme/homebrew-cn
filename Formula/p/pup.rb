class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v2.3.9/pup_2.3.9_source.tar.gz"
  sha256 "f417499d116bd8a7acec01b026d39359f64574f481282487e76cd511fb4671c3"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87d5d4cda02b0b86dca0c438abc4c5ff65ce49e05fa164badf9021f9fb96d40b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bcc66447d05c8a1fc1aec2634ac7eda5bc75cea829bf837a6b01c9e5cc6254b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "458b0710855c7f2cb36c36ca6b6ad8f7bb78162e6c638707dba63c89faaf14e7"
    sha256 cellar: :any,                 arm64_linux:       "0ec0592e03316a46c8613f802ec5386d6c3c38846810a88e77085e6d9a8d0abf"
    sha256 cellar: :any,                 x86_64_linux:      "041f65c8c49ae05e387ac43c71bea8ab1ae1a774c506087c4c00c4ed9f17aec6"
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