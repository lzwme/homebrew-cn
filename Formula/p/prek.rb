class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "ba04d08b90e0bb71d7700491456e5684300a5e13d01554a26ead561b6675d4dd"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5eec1dffa02233958c7bb2bf2a747a08b4241475ae71ef9a648a9c5b43203fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7392e585a5a25bf87e6ae09a0725f84ba27247bcfa177ea543341ea8bbcfad56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e6ca23ee19c3676ad459a39782b81c52ff70b41a94712430eeeafc02f01b786"
    sha256 cellar: :any_skip_relocation, sonoma:        "adbe82c4c2935fa884e82704d67402e3f6f8ec0c32f300e8d0137ad1c291e894"
    sha256 cellar: :any_skip_relocation, ventura:       "c07b554e3eb445bcc17b63c0c3eafa070e5b3b302b97686d61b7eba7f5d5b225"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2baa0f43a882428cbb6cd3508f21ea6831fdaf7351372cb036c5b96ebe7d50b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d516227a5c4ce75b4e771045666e59b5a15bee88f94a6caa3c2418f94c5505"
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