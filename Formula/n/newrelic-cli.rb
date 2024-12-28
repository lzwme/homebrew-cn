class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.2.tar.gz"
  sha256 "8eca7c0dc83b9f3af5696f212c7b63354598a815e8eebcb88273ee31319a58d0"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce45653bb9005cc5b00b1dec79635a4dbfee4b6e3b2d54959183aba0f7866470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7053bce832a232cfaee7dc22111702d9428d3c6fb91a8028761e474d3f3cf923"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf2844de5d34e6a7d2a40c907700c160654b85fff1cb6bb15eb5317a21eb923b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6a8d84fd89807b68fd99960f99c67ebc909df7e8d551b4aee881b8caa380a89"
    sha256 cellar: :any_skip_relocation, ventura:       "b0dd5a74cdac7d894854f66f036a58c2c9dd0695e05aa55dce90fd80f1e84098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f1fa1c866af6ea40bdbfc545a2b7e3090b50152b34104ab2b5130661a21b75"
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