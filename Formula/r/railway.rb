class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.59.0.tar.gz"
  sha256 "f5a403a9acd8fa8223f54b30ed5e7dc89231aaee17375258e4cdac8390b53308"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fa0d4dbc8e49583fccee34884866b8f6d1b19f92798060aabefd684e20c4c54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0630afd33b3399ad19369924f7d07123c37fef569dee1e25e8ac6c149518d630"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5017317f92f2bf28076b22e76a4d45b1f3f9d750114664907ac762cf49edb36e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f9d6aa1d0d1f50040c2c85bfc0064ef66810eea927c55edccb44edf34df2459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a650aff4fd89d6878a44ac3d1eaa897ff83b176757d339968f99fcf14dd207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47502d094e364bd61b37601360f5aea1481372d56d68b1be9855aa90e3d698d0"
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