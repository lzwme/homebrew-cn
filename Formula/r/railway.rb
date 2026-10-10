class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.64.2.tar.gz"
  sha256 "5f9a0efa4b31514d6d6cb7dabb26bbcc6d91cfbc00b9c231dbc6383022e066e8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c45852aad99d969bc52978d3157a8d0742c7b0cceb1e3003507c18d5941b3aa1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0e27da395d7212a31a6ec1165e8c8534400e1c39190820b66abc19f92e41f9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27a26599173dc4bd75690eed5bcc606ba05cc68dcbfa787e93e5e6af6e3bf28f"
    sha256 cellar: :any,                 arm64_linux:       "3285150168e75f5fb60eb5032b98bd430d58bc8f9bd7b39763f1dd0e44fd03bc"
    sha256 cellar: :any,                 x86_64_linux:      "6818e037649771cd22f33255026bd608b4e9c59208ea95c8f7c4a1d9c68c4460"
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