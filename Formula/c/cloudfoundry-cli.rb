class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://ghfast.top/https://github.com/cloudfoundry/cli/archive/refs/tags/v8.16.0.tar.gz"
  sha256 "85614a09302f0e2ea50f2540db85b75753e1afe878f764713bbe096ddaf10021"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e73429dbe58cdadecc2447d6d9fe5beefe7648430c89c1ecfceeda59d1d7baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e73429dbe58cdadecc2447d6d9fe5beefe7648430c89c1ecfceeda59d1d7baa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e73429dbe58cdadecc2447d6d9fe5beefe7648430c89c1ecfceeda59d1d7baa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c25d31eed8d83c11c8ffa7902b41ef47fc4167023c82aed1c4f1cbd8e4aa7c6"
    sha256 cellar: :any_skip_relocation, ventura:       "7c25d31eed8d83c11c8ffa7902b41ef47fc4167023c82aed1c4f1cbd8e4aa7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abcb1882322a7f51669cd3ffa2ae04ba6bbea529b1a0cd1d8eb66bd014b13330"
  end

  depends_on "go" => :build

  conflicts_with "cf", because: "both install `cf` binaries"

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end