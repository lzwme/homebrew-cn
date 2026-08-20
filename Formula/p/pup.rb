class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.12.0/pup_1.12.0_source.tar.gz"
  sha256 "723d2b372096295d3e515d3f17c09972c2aa451784a7355704a6db42d34955d2"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "043045d3dbd7dfd9133d90272fffc9642e24cd6a66a19d315a9ce316de78ac7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa3691f53f920d88f5a00059edc1a57cd5185b436cb026be0a27653fd8a19969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a942be7918e63314f7947274ec07a564a791c9eeabf0b13200e2e9d7b2dbd454"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a0d2c128006e357e4dd274717d45e910a3e4cbde6111db116d2dfc14cc4fa47"
    sha256 cellar: :any,                 arm64_linux:   "68a3d2e6e4ed1bf316259de46b2e260e943a5e02c184c8824198ae7b5359df57"
    sha256 cellar: :any,                 x86_64_linux:  "6f14c5ce4711753f30b60a97dd213d49be67b79ee5b7d11918895c6e1612bbc6"
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