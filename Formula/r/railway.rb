class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.23.0.tar.gz"
  sha256 "f0757217606534af30a4e54e93cb53f8f9ade90e56df11c47ab03a7c08685133"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eac9b3069f0564d09b833af6ec6d1ef5e4dfd2258151fd98e6169db79345dc11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb7bd5b1bc58e78a8d04689d2a90898a236d3da719e492c023a92457bcce22c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cf7b15b7183fab1c4b39928eb8571af4cab325e555dd9d8592a423c8229cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1d7e5e24ec6de3880b0075b022aeb18c49def823a0f34a672eac3c425c7c70"
    sha256 cellar: :any,                 arm64_linux:   "fd744259608a5cfb11c5e55dbd8703bd99f80152c3e72f65a3dd06ee7b478ff8"
    sha256 cellar: :any,                 x86_64_linux:  "03ed79f786ea339e0bbcc45b39304cd60d2524e98df4120d1a6743d05e804a84"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end