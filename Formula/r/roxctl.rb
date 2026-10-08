class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://ghfast.top/https://github.com/stackrox/stackrox/archive/refs/tags/4.11.5.tar.gz"
  sha256 "64d366577b9e32612de2ce4bc56f005a0c78440ff9930303b5c3bb15704d24d7"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86530d2d8a82042e9369d7939fd98500e16051d45a50a4c12135bd0e836c0cc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67f3d2c9df01b4838388afab9b599983ca7f05d9ec7014fbde5c5c754bdf69c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40c67b034239a46e37598dc4827396b2a964fc2c2cd0bcfaf97e504426305671"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b2ec33102d976900105afb7ad5639ed0e0b007aa1fa9cfd637f0f99fc11ab05"
    sha256 cellar: :any,                 x86_64_linux:      "34b22e77eb18f65eda22c6779b0b3e2ce993077b3bf7b63d8ba20c8c1d7a93fd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./roxctl"

    generate_completions_from_executable(bin/"roxctl", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end