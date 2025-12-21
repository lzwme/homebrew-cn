class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.16.1.tar.gz"
  sha256 "a23e297650170ec0b757b9aee3ea4096d831d0ccddd1ae51b3e6ee031d7fe9b3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af476f2a5f216f050cff4fd54277a84c53cdd5cd73d2f695098da9a50c6bf8f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a00f4699cef19c898fcb06b06f6d0b9cdd0f8dc61249f84f4680c763e712c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f19d8d7ff6cfc2a9ed45003cf29dfb36649e6daaf25d3db590396155cfcde2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c82844e125407c32ddeade4518e9026c65303182e6f786995bc7b27bd6da9b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085072a2661ffb933206a8d4b389a4fd6dbd99c42d79c0ec61e60a12a7be6234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d223d4f12cc7bf0ddda4c96694ca7fde7b9e020eca1435ad9008b3bd69f550"
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