class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.29.0.tar.gz"
  sha256 "a355f0fbed7784751332b52a03d6cf5e1cf434f38d0a953c5fb548e3cbef4866"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "678849e1af8e91f69b20151195f5345122cd34da9dcfc93ca0762bff40dc3878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5975f29c1b4e25c1ed89f9a82b26f47abc41efc9bdbb13dd0aaa0f08f3d2828e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eacde9776db642530f09ee2f4d870972da62f8ce1cac38118fb29ee807021628"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2489c777cf2f8788736cc052200706653838f373755113166029f364ebb3150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "126a50da8972d15bca5aa460e9bcd079034b047596e3cbbf83dfb9c088f74e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc85247a8cb2030de377da3c5cb6743374f887e04caaa4af25d7cc605fa9cf71"
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