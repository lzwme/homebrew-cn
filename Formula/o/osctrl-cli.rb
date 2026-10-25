class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghfast.top/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "f4ac2f8bc45ac845137dd7c733dec0108c8a3b7ac50aafa7ac6bde2efe57646a"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db41c8bc7b26b56296e9417b6cca11b2d3a14a7716a05194903e2ba163d048b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a8174766f0dccec6bb40b731a4b8c09aae669aa086254e1733d99dd7af85353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcc4ff56abb91a379d4cd0b3e4344ac797bdb56bbd535b4096ffc50cbd0f8fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "02d4b5b3efa954fd3c42312da4c95a025f356fb4b83b27d33c1ec0aab1ee2ffc"
    sha256 cellar: :any,                 x86_64_linux:      "daf8e20b76a0ae71a04ff4282e14add1c8b682e31ea7aab1fed7e9406d914634"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end