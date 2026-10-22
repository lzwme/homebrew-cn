class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v2.2.0/pup_2.2.0_source.tar.gz"
  sha256 "accab3075994ce1cc08fc7fedb0498be876fc9087864de468ec753cd1f195b64"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2cb8d0d8d7c9fc166efbf91a4603829055dd5f6a34060a1cdfe61a4a33699b02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8a10e5c8f7581f95df0366151f3676ed72430e6103d0ff6fbd7e53f0feaa0b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b15557859dc81986b61eb8ddb45b81aa3093a1b044420eda8c13cd5888fb934"
    sha256 cellar: :any,                 arm64_linux:       "8b25d910bbb134c30833e0bfee213c4c0c04cfcaaf0d4fd44b9368a2e84787df"
    sha256 cellar: :any,                 x86_64_linux:      "6778e4a22dc10b89dcce588ba1c097164d5db5eb9b1dbc6e705bf82d75a74927"
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