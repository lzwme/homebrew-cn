class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://ghproxy.com/https://github.com/octobuild/octobuild/archive/refs/tags/0.7.0.tar.gz"
  sha256 "332ea5672430adfb6b919554cf6edc1986b848d0226237374d0756113a2500f4"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59c1c47401e3260d2bd2506d91c092feeaf9323e7d7a23358c4ecdde40ebf836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1647e7bf016df46c6942d86093386061fb779357a64d2602a165b8196d37ae9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfaed5a5e6391537bf9953131121e3bcc69d55a60c8a2a0392fb5cc0fd28efab"
    sha256 cellar: :any_skip_relocation, ventura:        "97ee047318ebddbe10c64303fbc2c5c225b015f0733524ad3058ea234dddb792"
    sha256 cellar: :any_skip_relocation, monterey:       "559e9277930a7a10e2572d748b569727762f1d465790f1f1e092d96f602c0b04"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c18ac51a7560cdb029b495a1cf23b0ea0c1442dd6fa7a01850b3f26d6340885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01bf121bc97d6b991babe2bd02a08999526047602accd0f5088f77ce88d75d88"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end