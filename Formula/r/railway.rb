class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.41.0.tar.gz"
  sha256 "2f7293d1d78f7f6d5d2d9c301246b84c6ed92b3c0c58fd9637e470470dbda53e"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62c80280ad116fcba753f80bd9720c25c3afa220faae63c2af2f14af1e0c072d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0b142b08063b1b3dcd1c6238f633c50cfb54f4fd6ab3457148df7a385fc9ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc51724a70d8ee8bffe70d70dbbf31d3af5c855d01322816a7cc53bc3fef20d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "387383b16c4fe2c755a6068e5b762592f5ba0f9d8af8304c452c3cb355b5d35e"
    sha256 cellar: :any,                 arm64_linux:   "4fa55f00bd74142de8a4baca67070a4a66c4ebc31a06f07a35fbad9b3dd9b3ff"
    sha256 cellar: :any,                 x86_64_linux:  "74626c97bc74abe54aefa7a6dda1ae135c14eb1f5e09c45d8c37a9c11fe6470b"
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