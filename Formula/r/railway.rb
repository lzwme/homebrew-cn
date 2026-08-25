class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.43.3.tar.gz"
  sha256 "ca40bc9d42f5e5618db9c1155c9a9949a93cd3e322db07c03b553b8cd38aed29"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e9ff0885922a123a0137b37f2260a9b2bd619b9d1a6d35786236791c75af388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b00a2cdb38066a44f81c25f190b74a36a9bfe169cea7d0d76f3a1b48a9fc3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd02a7cafd0f28f2b3098b5806399d6d42be7f0b76559277729f8acf3737c7d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "138d0c66e75756ced691f0c06b8578035b763aa16e6bf67f9c9b6cf7828859ce"
    sha256 cellar: :any,                 arm64_linux:   "c4a9463515eaf13a4c090b89ed9a781b2f47140eb7d96d0a07ec8b21084e915d"
    sha256 cellar: :any,                 x86_64_linux:  "6024eeb0935452437b8130a6086ace35ce99938e335bc9b67ea73477262cfaed"
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