class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.62.1.tar.gz"
  sha256 "0f5fc7e3a5b35820103fe6e9f615abe27bf383a1a3c0710f4bfcb3f84897fc5c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7fdcf340fcc4a7fac50b25083db1b67a0e05e4555b7625112f183e32318da17a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c85a5bcbd45f8aa433518270443fd43596872e956ba16327e6a2e0860f5a6d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f65b8b92df0124a6ba49abe0373afe0710fb3d3530a6842461f5b34c71c53eab"
    sha256 cellar: :any,                 arm64_linux:       "047091e3c30d29b67bfd17c4a6465166797f957c1853a692d0bb4823eb9931e1"
    sha256 cellar: :any,                 x86_64_linux:      "915ed0bbb14dcd1ecacf1d9130140ed590677d2108d3e88a38ef8b44ad79401f"
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