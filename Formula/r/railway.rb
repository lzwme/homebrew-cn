class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.54.1.tar.gz"
  sha256 "a8e25623cb10eda0a388c2a7af22c22175272bc45ebe44f1ff94b3f8c51b4f1b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a4c1789d1fb574f3928c49dac38db53b543d6bf9a9eecce3688ea4460630aa0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "426d5358d9f977d1f4b2276545cda7ab788ed310d0710ff791eb960c509201cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a218246801b86148244b97f56c017a5c12a069665d40120a5e7c2c71b54640b"
    sha256 cellar: :any,                 arm64_linux:       "429026e43e53a47f314c8184c1ef14e125dd5f420bc57b22841ac2f96b1770ef"
    sha256 cellar: :any,                 x86_64_linux:      "8e42c7a1707d074694c2c4c199ad05c57c7d676dd181943c54b572bd8df54d30"
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