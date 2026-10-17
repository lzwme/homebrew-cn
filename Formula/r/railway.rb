class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.70.0.tar.gz"
  sha256 "d70aa2cd13cf18efd06b03e7f49f1527c8aa50f51cc0fb1c9c4cd42ffdcb1c4b"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae06a9ac8bb338322183ade113095f14da73cc5d0b6d08b1bf73faef41a43c54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1129be046b29d4414e06836cd07f50ed3becbeb04afbbd3d0d0d568ee2b01d39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "34709c191d5b080953fcf25d8d9beeb35504d0eff9ddefd47a0e6e0f20a2a703"
    sha256 cellar: :any,                 arm64_linux:       "d5de5025a46c95023ae73895f26e51e8b0e0e255e8e11d29c55473702e31171d"
    sha256 cellar: :any,                 x86_64_linux:      "818a8917e1d5845d8419da26364d4e6f9ab56157d431d50ead76cad1b1a81228"
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