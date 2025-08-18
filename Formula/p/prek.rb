class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "4434f31d54b8ee996b23fbd1b41d2d1aee7e47e34c6a855ce5e4abeefe01add9"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83aaceffeac4b8bd2063857f4616a155885e7e029c045a6b86e04d91a6f11e5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b81628a31770599153354adce66e108636f2f776d720327ae6cedd334672acb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2348b4ba5b669fae24ef047a4eaac9b42f86390c7569ebef797af4266c13e0ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d13a59a14b35fd71603c503257dfe221f951d1f55a890d490de99f41c44d7980"
    sha256 cellar: :any_skip_relocation, ventura:       "9a8a1de9f9f9cac42171855959d058fb6b5f217597f7a133b0ac6c7c1fc040f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d46105c5e3ba81ad73e63b092fe14d04a8653aa841902fcf21fcefa7ad1ba45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7193ea65e4b0da55880363eab8eca9c28fb4514b8a87af8089d1048192d7e6e"
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