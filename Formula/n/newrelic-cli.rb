class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.82.0.tar.gz"
  sha256 "8e6b6e2030d72bf4f9483355b4294849d993ea7939dd2e7bff7b3d539f815ae9"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "835cc25b967c04343aba0dc5edbf32db01f0d921b93f01c7c4d7a28cad8cb4d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360e6635c512666b10b75662f1c9fd218d2ce779b10eb0e72c15a0578de44f05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "564af9a2d7e90b1050741b9b5eacdaf27002436f29aa53d2b2b050458362b451"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fac22786cfe741b2c41d41b7d1c889f2ec803064884c676811934e5e1dbef6f"
    sha256 cellar: :any_skip_relocation, ventura:        "4a81f3738d040084f3ea1bb88acf3a97526b983fc5b92f44bc0c6dcbf0888b05"
    sha256 cellar: :any_skip_relocation, monterey:       "ed748b117a0113e406b0672ae9af5da67152ea62688a6e78c0ff2996d4c42cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88c1db95002b26c30d660951c9636c679dcfc90ed496e6135182d7763cd1f60d"
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