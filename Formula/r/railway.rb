class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.5.5.tar.gz"
  sha256 "600a8ba14dc28970a74ed0cb694a5b0912985a7896f3bc32ac915d2cd7c53cf3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebde80608730516bcacb7298fedbbfafbde66e324fc3dd58392ea63999fb389b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3a3572bc00f15cb2f067c71477bde16ef777474c7892e8e16a6c5794a4ce49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "945c409fd3d3869f1c05f2dfceb18ea37e58b0af8dfeb2f6a18ea5c65b70705b"
    sha256 cellar: :any_skip_relocation, sonoma:        "688364c0fa0c6af459736b746f8d06f61cd73d836a6f95e920aa24318b57e390"
    sha256 cellar: :any_skip_relocation, ventura:       "b2c2d8376df489301d2ed4dfd9b349813c713b51fd459d37311c6f1822af58d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07bbf8b33c77c088e6d836c90f2b1c95d8a90ed5f3d7d023b30f830147bb95ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09dcaeaf1a4142a9106bc4a5ef8e75566e637b6101c29fb87bead56d91e4c67f"
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