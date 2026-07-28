class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.29.0.tar.gz"
  sha256 "536b28461deafd46adbc871dfe5e11951e85067f32533fe8ab8d864688f988fb"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9979b33c3c6146bb6f62be32e840ab21f839e640c692fe4999edc99d4989fb06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be1d189e94c17f13c646bb6c2160fd5b46f1818d1b7986d0d8b8c7df2cc15c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8516843ba5e28913f5166e5221a25c42da2cf2dc459f5775fdc2d32f26769ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3cdc582be62eac4ee8297b91b105e25bf6a0951cb9ed7e5b62be30be772e14a"
    sha256 cellar: :any,                 arm64_linux:   "96b8edc3c49bfd7d150352d1208265bc7037d4de978d34cf14a2bfa7aad82d65"
    sha256 cellar: :any,                 x86_64_linux:  "1f517506bbb05b1bfb5e6445c3a1eb657e96ae2807bc96532efd3181a327c326"
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