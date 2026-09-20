class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.57.12.tar.gz"
  sha256 "d39f08e2f77ba6f27660b9a59c66401e397cec43a085d0170ccd0db35226acf7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84c7d58a3b3164d3d98cd902764efa2fbab9efbcc996bd0598f18581a11d0ade"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "218023d4c7ec87cb44539a33a3ec5f686ea2fc3161ec11bf3d4786d8e0f9f7e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ea8ba2ce04e6a6f4959f2d85b4c33803a75b96b0cc2b848813863f8e6508465"
    sha256 cellar: :any,                 arm64_linux:       "d643e8640ac1eb9a58ce353fa84d24a327375c2dc42d7b3862fa0cd9f8085672"
    sha256 cellar: :any,                 x86_64_linux:      "22b51fc6ccf5161935e5fa6585f348ef8bf9a5edc3d6939a7f2240471e0cc663"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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