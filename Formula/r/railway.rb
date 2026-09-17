class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.57.7.tar.gz"
  sha256 "9a8fac0bc3a494d3948a9e2657d9358a325172bce07a39b3ee3e3dbc115149d8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6295551300ea3d5fa52dffb3ff6378366344a9352fbf93fd906c8d4e6b4c4f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83f9a74b3bad0d03c9bce27566fc4055e5031e11ca5d4b1f071fb4f0268c096d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ee0d75637350097d37d59c5d2511a64be47e1f31edd9952f0398f455375d356"
    sha256 cellar: :any,                 arm64_linux:       "e32bc27a2546ff0c9664975d0c59fce5ffbb605c06ef1c14d3a825ce3e569359"
    sha256 cellar: :any,                 x86_64_linux:      "45f95686c8a46361bb254c7be5cc4bb4369583c17ca7ba5460f42205a8036705"
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