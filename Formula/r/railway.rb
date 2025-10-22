class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "ed787d09a3ec46d578013733d83d76171c8eea19d646098213d2827a7473709f"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ec00bbd8eab1a83f2620dc24d9ea7c52bcac1ec4ce268d81d10cdf257314809"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b5365ceb005a652693c2275017d6f0200ee1dfbbe6e9353adcd98a9f67de29f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf5fe2091fd1440549dee7c1042d45da34178b077a0d3d6aef6aae1432e958b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eaf3426d58d89f90ab2b44e521f3fe92e84eecbe0a5f8801ef89df16d81c9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf96e16358f8653629d2978a1a42821788083a1e284e56619281efd479926f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f713c230c8afc52a4be8bef8fa67f6f45c0ca3c80e4cf92d12c80064bc44b97"
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