class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "359d91c8c5087666e51f1031376425d37dedb1553a290971d2df2042c9eb6c9c"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54365a9ef83b998134d81deb8f05c3ac17ff711bc17f6830da5f850cc5c5ed9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a651de4d1352c5a2dca5234307275af577c0638fa1d6bf2b9873b41cd5887a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660d1ad813dcd3d7842d2e85bb7b1328a10212ba797c52eb7231e48739773d2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e2073ed5b698356ae4d598fb4bcd2422256a86af3e89ac467f01c515c2d23ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2ac56f7c04382289486c9518557a2f22dab271d7693ae28a15d1c4806c65fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a883c4cc62115d1a226b8f14d392b2bcf62095723787c8b956e0ae5a88c300c"
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