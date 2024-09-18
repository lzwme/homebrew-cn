class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.7.tar.gz"
  sha256 "66cfddf05f5bb5e134adb87aaa6ac0a5c2c611495bf2b0cf9cc08cc151d2e752"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bd113dd654ba5254b51009791dd06bca88bc4fe819607354421dc73309d6c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6965a3fe80506be79a8025db9fa17dba8799bdbdd69aeab39f45a21c033c2b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c78617e0b6a18a4331b5c83888624cd993a7bd34592c724f3ce291bf6d8336d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dbf82b856901ba5f811254ddf926eb52139ff34afe2283793410a9493e25075"
    sha256 cellar: :any_skip_relocation, ventura:       "52b6a9a3f89cad1961aae36aa2eca8bc7cd4758ed02835b98748f8aed09aa353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e67e2e9ccdbc7480154cb14dbf7f1532112253af23310178db3aebeaaf21cf4c"
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