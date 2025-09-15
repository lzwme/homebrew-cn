class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "5a799a4957fb80afeec7736f123518b62919d70a08d86059b0b5479fb92c2047"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c8813cd617eeaac5de5be208985acae67c9667a71cc5f0e6bc72b565a409f60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6ba1669fa7550a3ae383252917734d0b9ec327545d86bb77e808be0f9770e61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5947c8d6e12b288f9993c1690f7960c2da8eef81d6ea55f927e4f2b8f5c1f7eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "109fa7ec3cb9ca847d597383e2486304fc2e9d43824ec133871f2f4812fce1c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fcd988cabbe118987b0a5c66d237ebd6709ece2cf2ae2bc9f99f9f4c0bea577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a018a4cc76f3d88d5b50e9353ed15dcf78e84a030ae0f04f7b668810fd024e"
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