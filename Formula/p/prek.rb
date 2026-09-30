class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "f780f4ee6b306270f1d9ca78169ea917e17723d360a437d4da933151ad8e6962"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2afd427d864f3554f0d1c35ed38553d4ef086dd31e34b73489d1c5c017d5c0d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7fedad9f6c8de81bdb9369af3040a876e558816c6fa71296fc1989d39dbcde4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6974e6df8ba7af99aad1e30f9325eec8f3eb8e0bae73c072661540f7102faa1"
    sha256 cellar: :any,                 arm64_linux:       "f5a878876a8ebb3ed77795fcaa00b816457ef70e8e7dc7e6c9ac7cb710520360"
    sha256 cellar: :any,                 x86_64_linux:      "c1e812723f41e31f069b432d7c860a08158a054b93e3cd41b8aef155b9f42604"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://prek.j178.dev for more information", output
  end
end