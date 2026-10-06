class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://ghfast.top/https://github.com/Y2Z/monolith/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "71244b3cab7c74a5af9e40edbe4e9600fa78f46e0bd821510d4d236b7342bed5"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75c8fcf79ad6bf62996ec3a6d59acd0db5ab8fc9597dbcaa43e2034d36a1f423"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "327d94787cd6003c0a61cec62effd3cf9790be60d60840ae93764e912f48f546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2aff2ed54ed35f250ca96ccf5def603303e6fff457f0429dc6c745080f6dce69"
    sha256 cellar: :any,                 arm64_linux:       "c6cc2f6b5d20a532cfdec2aae543e65bd664b86993149dc7997829469a76425f"
    sha256 cellar: :any,                 x86_64_linux:      "121f478d0116b7269ecc819af504c139f7f89199cd5cecdc015018dfc42de030"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end