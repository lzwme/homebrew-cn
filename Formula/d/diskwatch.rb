class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "3445fa2b515c6820ae393eb1dcb321fa35d08ffefb71fef86660c5dd0919b968"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac1ac4788d4cd7f7d6658eed0335704660a61b4c8d8de7477d3fb1c6d7de5d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac64b91ecf9fbd6556162966f22988b7abae11ce4255845df439da4bb3e2ab6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff8210053589083ffdce631e0ff96b5db20440ab7ef6814faacb3beae843b24c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2459b9077a4d74537039ffc30f30b835a1b05dce628d39998c0a12202de219f"
    sha256 cellar: :any,                 arm64_linux:   "7bd56d90d3ca296ca21aba8ec269dad8876f7f2e2ecc6f5e318cdb8a5c8805f2"
    sha256 cellar: :any,                 x86_64_linux:  "2c5c6d431d48a478d53e043009b099ace2095c90660354c97d42763891b81ee0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end