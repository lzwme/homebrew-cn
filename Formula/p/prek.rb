class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "fe4ed382144aab1640f1b3ff277ba58a3b1b69b232d5ab226179b11d21f7798b"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c699fe52eea47566f14ecbc4a63773e95f09426260c300e46a3fe279b88012a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cc44216d16963f14d6d55d6f91406fd78c7ea4f625513e10bf4f316fa098def"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13b1a334d185d56572aa080758250801838812dad8aaefdd7fc5fc95c7e2719e"
    sha256 cellar: :any_skip_relocation, sonoma:        "583921dad8a2674257d9e2c82926121a4b90c6bb1c389cf7755b0a935538c7e0"
    sha256 cellar: :any_skip_relocation, ventura:       "9e2f74acd6545ce9b1ed1b49d875237d6ff59054bd08197a98abbdbe864c0522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f0f851b6ea7a621eff007365d6f7c529a16be72f0dba8895f07602d24676591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6515ce0ccf0e99ba668d24ee8114dd96c18d8c361126657d8542493e617f038f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end