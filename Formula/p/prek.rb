class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "0b1286a5d7d167ed9c7a68ccee12d9f50520209081a6e6451007de9c98722af7"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4c7b0f76d015a97fe61133465353b248a9713843b9b6dc3963bb6114f63861f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3775d588fd78abb2e90387d245dc09eb1497e1427ea0a5e9037314efab1f7eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a3bce99ed0c4e18245e52adf484e8b697c39ca181c5f10365a01f980027baf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9d7e2388fa546740eb3dc864290c698d1f7253856d4b97581f7a871cbbc342d"
    sha256 cellar: :any,                 arm64_linux:   "bd525e25e9b15f0ee449b623b55402ec54ca36071a968382416cc4d236793a5c"
    sha256 cellar: :any,                 x86_64_linux:  "e1d74a3d26bb4d8b1efaa0660f766ed27f966ec4fb5876b1d8ab21674261769d"
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
    assert_match "See https://prek.j178.dev for more information", output
  end
end