class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "79be786510217fa97fa02645b15b60da0181f30daec1a7f93ed459afb5acc77d"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aea135d930e3051d184af7b20b9eaee3dca84345d7ec79a0a38304c078eff75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf760bd3d2fa1f0cc1c0f0064821eea62dd4dacdf99181312ea85b372100876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb167fb781c4c1f5a9d2dfceca8a8e1cce3f3dbd84a6c340f682b0b98656d843"
    sha256 cellar: :any_skip_relocation, sonoma:        "a494250131ac6880de62f140c0d9bc93da121e25ff62660522123a25e5817ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f7877b2e2b38e87410e8ab7a2c590807d5ed0dc3ea1ddb02ecc4cecd55a782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4429c0deaa57ae5e24e2f1bafb6abf48225dc7976d869f70f506028b556299c3"
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