class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.19.0/pup_1.19.0_source.tar.gz"
  sha256 "4efca022a63d3a247f68aabbd44bdf851f1a7240223b144c7e6d188a30646029"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79ebba5fc36f524fd1b310dc41b1efc849d93a2da7c524e0cdebc4a6dffafe82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cefa91cdbfe4df19f27cb65cd696c9fe3843aaca2247c0abb119df73067095d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46d363f99e967aedf49d1f8bd2a453e0241eadfafc5621c39fb11e8e3cc48314"
    sha256 cellar: :any,                 arm64_linux:   "73c8a7847a2dd3c82627aab5a66f4c91f5af7033fa088440a87df15042333bfc"
    sha256 cellar: :any,                 x86_64_linux:  "f0a21eedcb02f58b181ef78d2c2472e001663792a87b2532c21486ebe210cdc5"
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