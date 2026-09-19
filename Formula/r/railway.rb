class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.57.10.tar.gz"
  sha256 "d0a55ea9e44fcf96a3afdc3b1d7cc1fc765e923804c0caa1d7650bcd4dfd288b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a19911f48d801e896412055bf4aea16fb416b07a2687d7bb94d597c86d7f4539"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "616228fd2c7f1574a5c0cb5af87e6539093b61cd07f811cf371f49bf3d5dfe05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78991c566f7d857367c1b87a95fcdb823889670d0fe0bbb1b53c6631089a61c8"
    sha256 cellar: :any,                 arm64_linux:       "507cad21010d66b8cae06a948266349b0069b3c80e5477d410fe56bd4c39e417"
    sha256 cellar: :any,                 x86_64_linux:      "caab16235421c45a19d5cfe33b53b43c7c91456f14a69dfc4185b2d4b4a0ba7b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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