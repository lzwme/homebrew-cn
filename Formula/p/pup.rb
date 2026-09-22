class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.23.0/pup_1.23.0_source.tar.gz"
  sha256 "82bb12b873cff2a67ddc3dc1f46cc43bf49070a92fdf700fb7ac4bd8fde0612c"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38cb473f0835dc6ce97dff2e03b0d610ea8f47f63f450d965ac4286be441192c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a59decd6bdccef5f78c7662d9b05d41c30ffd7269040911bd942e0541e9a7f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05d88fb3c17804f544dcd124dc517e2019df2207593dcc8696e2be21ccbc5d87"
    sha256 cellar: :any,                 arm64_linux:       "0ebaef3533eafc2783eeacfb984728d93f5ca95a2a8e13ea0611e92b3978b443"
    sha256 cellar: :any,                 x86_64_linux:      "349b2a845b8db9ac3e5b3d01ac5ab7f551100e085a9ce961c9276343b1bfcadd"
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