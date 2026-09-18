class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.57.9.tar.gz"
  sha256 "b38f6da300abe910c5081b89177369739e6f257bb86de444b768e8617536855a"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22c593cc0bf756c9987bfa9acd0ddbf73a042c09a70bef96c0d25ba8a6347e24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "830ed460731394023c1fde3d69369ca3771d677b10fbae72642f2dfb7e39741b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be2c12be574d6043fc54dd574afad22034ca17d39daae650edd73bcc12e17f14"
    sha256 cellar: :any,                 arm64_linux:       "9e17baaa441bd62c9005362eb2b3e4e0446a81f63db3972244d68eab8c43db86"
    sha256 cellar: :any,                 x86_64_linux:      "317b49813d87285e8af9e1c222aa1064e309e10cae370df340cb5fcf2550f68d"
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