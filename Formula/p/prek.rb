class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "7480500dea21e8d457e5fa189ed9061fbb1219a897c28c66dc97e50afeef13f6"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a885cb0631c31c8dbeca6458897e7ed975c30ffb18a9a2e843b572059b01528e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dccc35279a1c9e90a65ad99170c13a05fe2250c4720c59a0ef3a497e525171a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "622192b0d52f132b3176020ff9b7d7fbf8de6efdd37110f90158f7bb8cd43353"
    sha256 cellar: :any_skip_relocation, sonoma:        "2477609d889aaa703ebe8ba92acb46162ab45bd57b2577a51bd63029c899b11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8079c0212b55e42027084f25d1a39c0ad65c4be2b4900fb02607753c9b861d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "772fd8c8f63aaa77fe17f231a949b5322060ba920e67b98f6a78f2902fed70d5"
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