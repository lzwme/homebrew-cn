class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.6.tar.gz"
  sha256 "5c10741cf5c5dc2120901f5ab1e1f9cac2aac5ed9903399f50daec2b63f9e929"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "10f59da565324db083d13ed7ed521d36d62d23c0cef6c2b19377d4e3773e01e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c676f6d07de70ffe76fe48d628481acbb15236677953b565b4d2374b97af09f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1693d0bd269fc1ba93ec3b64cf5a0b5c2d98bf25148cef4aa7812f3ce35b7dac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ca9ad72c237d2a12f86a24793013ac158abdef5338fb252b7d3604168fd829"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff365c67bb15c13ebd64bf38a04db8dd0faf660423cb0f6d4d02df8616ef2428"
    sha256 cellar: :any_skip_relocation, ventura:        "22718299a22b19b545bf691502df02dbbb01d00900b7df130f8e4a51481b0eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "71910791f9cfd94e19be40dd3d7ea2e7514c511255b8238311f5982fb0f98cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3714cc976efb6fef252b35d265c2d7f2996e80d4da9fea8411f24015e7b6880"
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