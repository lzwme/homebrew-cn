class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "d8a679e5bae8276c3c7500dbfd51ed0c789413f42b72d3d1ca8915869f93c9e7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a415b75bc2f56f3d21d8b0c3db6d4f16e3b1c4facab0ce8f5667e1eb9621e08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5b79bd18dfb552a02acf6122f4ba5e19579e85d1e2552bdebdd9d53550221a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4be929da6e01179316a42660713f9f7113ef502cd6f0218b359ca282bcb1fab"
    sha256 cellar: :any_skip_relocation, ventura:        "b25a16fbf714cb1b21119e5d7765a5022a56b5406bb3883bb5ddaeabd57b4431"
    sha256 cellar: :any_skip_relocation, monterey:       "31bc9fffc358974de68651aeed3acee20a239b628dba0a4e349d48262d3fe140"
    sha256 cellar: :any_skip_relocation, big_sur:        "80307012a94cbbec2aeba95dcebb73da772d6dc3271958a0f9dc455ff0582833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeb1e41b8256ffeb9d0f67bb3a5ea160045fddc4eb373e39eb3d1ea72bdd92fa"
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