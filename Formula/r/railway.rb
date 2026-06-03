class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v4.66.1.tar.gz"
  sha256 "99a7995e095425c99155e74825b3637177db556f7b9083faaafc34dd7a4182f3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af17de3f802dccc2647a38e19ff43fcc2516e55ca86956a2c9ee9ffc14c1c921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32fe80563b06ae51bbc507ff09dfa98579c7eae33e5d19dfc564397cb7557253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d6a96948cc7cc58f536c863f5fcc8989036ff10fdd9e459042781db679210e"
    sha256 cellar: :any_skip_relocation, sonoma:        "80e4fef53d247b096608f8fa530b001e43619200faacad487e027b7200d500fc"
    sha256 cellar: :any,                 arm64_linux:   "08f0c570146d71bdb2620c35cb67377d88201d042e32dff537e734045354ead2"
    sha256 cellar: :any,                 x86_64_linux:  "62ccf5a80dc51a1431a53ea228d62f651d96a2cfc0c617c99fc08aa5a46cba13"
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