class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "2104a7ab915262341d8454cb344b317f658e9189448b27d5b90cfbba63ad8de1"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "915b9f3fd6781099783b404f6a42560acd146aed07e0c528e309991393588347"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e278156fede03836186139c8bf7238876dfa48352433a5b958249c66ea3cd9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9096e07ccd32d1500ff93ff1628438cdbe865e901b79cb3128a14bbee9a17f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b47e1897fc7e449bfb15c89c8cd04cbdbe9790fc7df1895baf309fb2f6c64a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d2d70adb73932e4fbf5bca4021542935a6e922b2726baa2cfdac3c318a099d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c61c3e46f6ec46a9238e32e68ed9d31c99aa606f90328130abae1062dfe538f"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end