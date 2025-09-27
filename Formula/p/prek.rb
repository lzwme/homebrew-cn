class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "73665c5e29e3d2a2f1445afaf176ddb9c8cd67df743419adf0f37905405074f8"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7232718caad9a65435b37abda90ce6f6d2025da5fdc03f27e53b7ed25a6df2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "256de687dee51ae29e8419beff4102a8b8272a8ffbb8717c3fe159812c054521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea54c2f51f56ddf4077a1b0ac5238968648a84d0b50ad06ff15654e49907c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9f9fc180a57e4eaefda0e22f955c0e52a85a0534824f8753766957568ea52c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1ae44a2a3396739fba6e47adbd16b95e6b9660136b6a4117a1cf1d8c3c770a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f332f3a34f3c7e98fac5d20b11bd6d4554bfd642a242ac3b0c4bfd12205184ee"
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