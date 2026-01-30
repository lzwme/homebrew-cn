class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "ab0981dc67bde76487632467ad3b504c9754a1c261d3f3001102fe1dbf11aa3f"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e10f47414c1d74f1c38df01ef91b93a682d765c3ce5c92123a3d0d21745d4c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422a2244614f77c82d11e0c880de61338eef9ed308d327637584ffc4e9b6907e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9130d4a4454c7aab5af7ec25299e099cb245bc8933ae9baa8b0a287956bddbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df2f44f7ec45e15c87f54c2c8ce7edacf68f41a80c51d627e3d120d13e32802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59a3328e24db1181a436294c8f8523f977dbde83178000e2dca42bf10cff5b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ad42677779271015fabe4483618e69811ca0ecf761584e26e3a4a0f1072efb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end