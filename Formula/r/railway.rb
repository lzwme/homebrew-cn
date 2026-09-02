class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.47.2.tar.gz"
  sha256 "34a6a97d017984438cefa1c35ddbb53c0c332223e399e9e05f59b52428bc1c5e"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e42e5ec9342ed8a5c2a8d399803efe5970266b3f1bd2ffc58f4b06b77bcaf8a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c8768a43368d28342cedd354ad114b0a0ee9d13b5eedbd0ea7041f966ac77c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "243e9dea28896423d06bf982afaa33a9ca11ff86e54d495690bf65ce3ce36bd8"
    sha256 cellar: :any,                 arm64_linux:   "e2b6bec97aaea3c149fb8bf13718b62bcce8d7c8b33f99a174e0124b2567b06e"
    sha256 cellar: :any,                 x86_64_linux:  "e7a64d7ed92bd135200cf2742ed6f2c99ed017151d8b453866da0be7cf030dc7"
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