class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.45.7.tar.gz"
  sha256 "bb4ed6c55df7fdaff05620f2ef32de29a9fe19a3ac30fdecf22ef4aa7bdeb1b8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d16411f593b3404a28d80505cfb3e13e18383a56540c7fea01c6bdb85d2fc1fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622d7b2d2c4d26911fd4043aa2f8a0ac8ec5bd37b5d51e50614aba8da4e799b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a0e7b5e4b78cbaffa2f3921eb17a482d8ea076d5ce18f69260d32224d308a37"
    sha256 cellar: :any,                 arm64_linux:   "86e64d7aefed37f672750e7f45827dc415586ca3b0dd82d1ddcab5cb4840b711"
    sha256 cellar: :any,                 x86_64_linux:  "dd783cb72bf8fc93776a1a9054c2f8d282f5ae516dc8d815d7ebd68cd1d22210"
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