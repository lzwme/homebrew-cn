class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "d99a976efde4d717a9f4aaaec7e617fa2360abbf9a53e720ca15ffe8ce48563a"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b78b47d433be6453e6ef1601ff156476aff3e965bac0291febf8635a7534b32e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7837ca120da2d2420a0786badd9648e6fcef8b07d5405419c21de0a9f4c4884e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3db63a41a2713f0a5a4ce9c7d73adc72f71a091c922cc49bcc5437329667caed"
    sha256 cellar: :any_skip_relocation, sonoma:        "24baf66c27a419f0c259ddfef774f60caed962019f1b3388953e271b6953ad63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3d6b04e485bf43129eb696cc2adc4a8c61bab5fe51acbba8eedc48726692bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba3e12b57eb1f4f1f50a494e2cdfd6fd8bbe8d0518f8b655e690cfe9835dc680"
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