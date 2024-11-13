class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.1.tar.gz"
  sha256 "72c41e40e20e5b3405330fd7ad850ec35a9b99361701bd8c5f933a91322300d5"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f3268e4e27f5f6c29209fcfb791d48f3c770c2e79c3630e1f3e0328cd684651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6da56413e549a24a3bbaebd4568d7ff5056175a2214b6bb40fc4a1008b5f36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d37265e5054609e06e62e4d3c0261bb4fe8e18c2fa4417b375f4e2c97fc10198"
    sha256 cellar: :any_skip_relocation, sonoma:        "edfe6ce73aeb9a04a854c370933d8019cb4301568d758b3b69676816eb328813"
    sha256 cellar: :any_skip_relocation, ventura:       "7f3d8e1d53e3d96f9f3bf6055e725c68fa0af5d5b6ed651dba4bcddb582b92b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1977fce0741e8e026662ef01139a2fc5c642fbc3b053aad897509ee7266d4e5"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end