class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "4118227bf9a157feb45f250033ebc2fc2f481a8f535d2b59d4646705b1ecf4a0"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63a1e14db9cb1570cbd24cfde559e43a585a69f07599b23ab58595c6b2374601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ebfdd23703038f81ff2171326b4a4d442b159d376a0d5c8f2261d2fe2b744f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc9103bad221796033854c19a5ae7c328d2ca43e750b23a5f5efefdab9ac09a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef2dd371e327fd5902c64bccc6fa4ec63f4347e6b3f4ed3617708a3dee437044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b1b823e9753313a51322b7e36ccc8fbe7b86ec21c2e56f6020c70f850b3d0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "316d9d69f8142540df353e791284fb45d7e3f5f13b862572ed08af480153e956"
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