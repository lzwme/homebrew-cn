class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.30.3.tar.gz"
  sha256 "d4a468f6db29dc906fda2231d867e7cde3caa1b8996b0baddf6dbaa3392d763f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3c5d5e5e6d4c2993374e83c2297e776e273b7d4fe43907c4aae17570bcbfda6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c125c383405fdf524727b5566accde72d5b83e48294f72082fe690b679db19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c907e7a7d74888a956c5fffc83c358b3049dd40b0372c75875a992a5d93ab74e"
    sha256 cellar: :any_skip_relocation, sonoma:        "15966af1a2006f74cb132763e0407c351887e88692bb08d5ca8cd74d0e61c975"
    sha256 cellar: :any,                 arm64_linux:   "cab4ff5eb87c627429872d0af1197e461d205cd83260f85ac0eb8628061d2cde"
    sha256 cellar: :any,                 x86_64_linux:  "43ad5f2ec0516b0b20c679364222b0b16c7a4fbad68b67c9a5ae94b6f8e0760e"
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