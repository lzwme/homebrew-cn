class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.0.16.tar.gz"
  sha256 "97b2a9f550f9d2dd6d35fe758c44aba0141a4c3eae4fc8b742e2af02be509c9b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bc45f51b6f938b558d23db5b8e15160d0d7437a7a074f4ec318d996c1ddd571"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7876fa3a1ab09f702f41b9c0efbab102cae24cdf66b81ed515235dd63cbed54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67ef6377a79ca6c83643fb4b9683c8c84eae8e83a8c44eb73c2bcb19625fd271"
    sha256 cellar: :any_skip_relocation, ventura:        "5947621729c6d7d719fecbf57acef198eb900210dfbda368806b38e2b90da893"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa585c87ed6fe0ea01c8d71345d42a2a497f797e80a809251a7e86e412f2e5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5256c55fb52c9908426022090ac4ede0a26c25cc75a7da240ed10eb01933ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2caee8bd9dace402e805d4387ccabc48061012376d5cdb7b6da0d9c30fcf802"
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