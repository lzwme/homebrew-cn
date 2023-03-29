class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.0.19.tar.gz"
  sha256 "7c83ac9f86d3998b811c337889acae68e66c84f56bb49ae7c359561a08a62052"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74766bb90ed68bc3cb0371d52dea139f8fecaafdeaa74639e3c7932a9598eaf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b41bdae402c58f0a3f5d1abcd5bd98ea57c89e4edbb134fe1c973dfc1d48f76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c478e4f0e510c5222e814c46495d2e41d442748d6a8f823e0b88fc41e4291c3"
    sha256 cellar: :any_skip_relocation, ventura:        "f0b5578d2c0c85377772ccad90bd8cefd8abb7d0e159b3eb99060c74c758de27"
    sha256 cellar: :any_skip_relocation, monterey:       "9dc6857cc02229b3736a7e6a7b0bfeb7f0119a7d0445da40e193016dbd72b75f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9f1793fb7b07a8518c981ffaceeb7fc7aebdebb6f4170a1fb7aaf2f05449cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e02d604da0beb6130d5edffc7e7e92357be055349bb3b563b3dcd6d7986fd4ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end