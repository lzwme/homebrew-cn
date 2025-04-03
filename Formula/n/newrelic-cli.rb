class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.10.tar.gz"
  sha256 "4a4b0986ff5eb9a21287e3535ebac69ac17866403bd46d4c22ea292f2c1b886f"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eb1d8d57b3e00b70d8f5f1fe03cf3f2c1ec9c8e0d394ac37908553e97b61865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c05be70ce1614d387e4978d322240d27cec6d59b1ec4cfe338fcb322c76ad55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e93fa3b236f6d31f819dcf83d4943e71a36e52e0cbc4c764aa718413764efb48"
    sha256 cellar: :any_skip_relocation, sonoma:        "dce6c5194b073311301e964d28f189754a6f2450e4ee6083b578eb9229fe51a9"
    sha256 cellar: :any_skip_relocation, ventura:       "8ca9a3b2b7c83bb1309ca6e12b82b11eba4f944b4085e75350706a56b963732b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4865f2af936c6a430ea45fccad1547c9ed13968f8929ddac081d069783ecdbc"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end