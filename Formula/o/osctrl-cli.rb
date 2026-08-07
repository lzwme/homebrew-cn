class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghfast.top/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "c63b0e29f12068bd41fa573ed2169f74fe120bb01737173c348d07bfd8eb6a09"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa9bde838bf95d8994cfedcc554c29a31fbfd18df1d0a909a80304d5c7436861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2de6f712f74bf76dfbc5afecbcdcd33de9c861a3fe367ffb1bb3e1d2b39fc2f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0213204df369d13432b99e4a00cd8fd2bd36ff299dcf95f0dd921ab2b06029e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "612ec18b785a0e30f82ca8d3b3df2b5b0900834cabca56f2f071f12d000c6536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7819f2b90e3fdcf03e719f226670843bb0f33a79f7a694d1643cd8b83cb723"
    sha256 cellar: :any,                 x86_64_linux:  "5c72b592594f8aab5b473c29ac6e43993f0adf317a3c364b016f4b53c17e55fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end