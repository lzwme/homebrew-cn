class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.63.3.tar.gz"
  sha256 "d111478c266adf8bfe8d851609688a0f52f4125eaac7e38bc266477422f0e5fa"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d762378e56ce76a5e620552ebf27a573805a02d3b2d0be38b367712b5d1ab8d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "214e57736212e87a785b2d7673e186b8eae4dc01cdc413bad01d7a0baa760c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4869066f0d0fb0cc3248e0ce8e29d89cffef31574a212b0d8ada02ccf6fbaf1a"
    sha256 cellar: :any,                 arm64_linux:       "bd919bf1306c8dd22b8e95caa68fc4484e36938ab27033864d4db2cacd5c6dca"
    sha256 cellar: :any,                 x86_64_linux:      "cd099f9c9ef6d98c7e28acbec8d2a647f8817db7961c720843d8e325bfe38c16"
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