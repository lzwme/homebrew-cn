class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https:woodpecker-ci.org"
  url "https:github.comwoodpecker-ciwoodpeckerarchiverefstagsv2.2.1.tar.gz"
  sha256 "18aeedd92cd33d7e63b29a657f1828617cd393a939948a83978de8a8de4f4e70"
  license "Apache-2.0"
  head "https:github.comwoodpecker-ciwoodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b9396686978044feeefb1c0c409f3ad7ad91061e1ea2ea44d9c2893c3106d18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e26beee6478d93dfeecb05b38d2687b609d9c9216b6cbcb67575ba575da5b4a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aebf5236877fbb50aff615e0f2d623ec4a96e8854229906195675e9b284264fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "30ac3a0b3925e701bee857788efd3851187eec32f4550d08a06317d3521b4790"
    sha256 cellar: :any_skip_relocation, ventura:        "cfa7e5c9cb488847154860a624585a406cc054bd572e84de1c39e3fb89bea156"
    sha256 cellar: :any_skip_relocation, monterey:       "e749468f42ed3533ef868f261c74e1021fb5a76ea0b5fb91e465cb0e67b62fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6cf07cb9e9e2ba09881298974b64fba883692b90a69bf43af524267d7d55ac0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.orgwoodpeckerv#{version.major}version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"
  end

  test do
    output = shell_output("#{bin}woodpecker-cli info 2>&1", 1)
    assert_match "you must provide the Woodpecker server address", output

    output = shell_output("#{bin}woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}woodpecker-cli --version")
  end
end