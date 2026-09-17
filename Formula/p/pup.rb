class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.22.0/pup_1.22.0_source.tar.gz"
  sha256 "dff3b15c6a67e0eb06a6842478dbb0241df89310e607a6a721b63dcb281e92c1"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90998c50c8ed6776c168a9049c3f92348b29615567a4b32c79f31a9519133bac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d3ee1f4fba7df36c1862108713cfd8cab5e318b54be5b78ed6cde71d4e2c8d1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f985e75eed5bf542e5bea95e582baece2508f716e73023278fc2fd24e744cea"
    sha256 cellar: :any,                 arm64_linux:       "7110759b2ba8215434a05550d650e9108f7a47134dcfe32153c8da7ce9f7cae6"
    sha256 cellar: :any,                 x86_64_linux:      "b2667af7b21b6236b74c79378042c234d859a86720f47a4b6d06fd4276818cf2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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