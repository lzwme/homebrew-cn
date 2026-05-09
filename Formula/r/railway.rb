class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.57.1.tar.gz"
  sha256 "be3011ac0c9f0da24f1fa8c6fe0e5541695fbde97835d5e4dabef9c9bbfb14cd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9c79ba0070ef81f8dd5cde5ea39622b8027e0d2b0839915121844e947ecf403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af322abe458bf27cf856b35fefe27a75a72194e5a33463ccda18a1b85fccedfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3366fc3e1fffc4ac4c674be169dca706fda6517a89dd05f6ef4be6be790eb54"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc76afe71b850a5d9512f8463fb5b5bedadf177abd51aea1b27fed8003158404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04697696f34183b438ee5441151b1c27d57ff720c3860a85cd8200ce4f30678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece853e8ccb59156b08be12409f673c18acac1e0b24fdb75cd65da3be57b3dc0"
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