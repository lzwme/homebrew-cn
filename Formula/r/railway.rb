class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.62.0.tar.gz"
  sha256 "2753b88aa5bd5e2342cea9efc35623a2ae912fe6dd9c0170f83f67154b1eb85a"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76a02c21d030b6e792e427109e5f81e07f2678a6f74891f3424105be2c96bc39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea1902fa3e6c274ede056eaa0bfe0a2720b2bd1016aa547c884bb56ece7a18d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f5c9d218aa18b72d60e8941841733590f0858639c7226bea31e7442b436c327a"
    sha256 cellar: :any,                 arm64_linux:       "a75bfc0eea018ddccf9541bd99ea1a5847219c4099e29f58c06b080c496d280c"
    sha256 cellar: :any,                 x86_64_linux:      "a88a4c3e18b3099cc2efb8937bec684e9ec620b79553bd5814d555c80f598427"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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