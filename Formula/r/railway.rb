class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://ghproxy.com/https://github.com/railwayapp/cli/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "3857af010ba840ac01d66873819174e4832ce85d3c2ae8b6034f8b0427df5a07"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afb65ea4b9c885df198b9e78c425a990a18d70840e4a7ec75329304ab931ea32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "574f68e63b94bafa1ed59223c82867ae7340ded9d178c86eb41a1aeb2261acc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b16141573f53baf10d4560e4acdabcb914890cd63892db109a93af9e114e2c0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2393e16b2b5dac3c93e29bfa8ec06ebfba3eea10617d3435326bda799c67041b"
    sha256 cellar: :any_skip_relocation, ventura:        "023720c2de5437fe91dfd52d652c9d1bd262f299c5d24a8c567aaa23d8a1f56f"
    sha256 cellar: :any_skip_relocation, monterey:       "ae91f551f9bb07d1cef4d85ca8ffb5cd369f5e46634001c9ec8afe4d4ca13104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83d333d772da4d262b82286ea70fa94f2f7f5bc21d25a2c45c756e55ee1a05f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end