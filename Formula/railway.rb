class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.0.12.tar.gz"
  sha256 "aed5f48af7b3b3b08a5ec224e246a6f5e71df46a5ab502fe53ec7d1539681327"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2809e734fbeaaffb2bb4c2ee01a404b9219705ceb108f5ce76f768d884b2c580"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37c562cb72f91ddd89b1829c611d246fb5f4da52c371e92477b7b5b48daa1dc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7284499e86d6a962acc1f4ce31c4295418e13c35f08354a68afc666f8f0a1d9f"
    sha256 cellar: :any_skip_relocation, ventura:        "522ee3013f6063336d5b8500a0325c15c1a5cceadba61b9b0f0095014076f666"
    sha256 cellar: :any_skip_relocation, monterey:       "fa687efb3d13a76c47631d439d103b0abacb352895b297c808f9aecbbf62d34a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba53bee488d990d7acc68b78618f910ab4dcd2d6f864079d1f4b661d8d6d18df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12ba5834df8ba6a6f85d59eeb53523dd78808ac22e07f39a653373006d6a8f65"
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