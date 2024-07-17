class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.89.1.tar.gz"
  sha256 "6bdfee6fc1ea3bdc0eefa674517fed48ac7155bb4bc1173a124d715801ed7c4b"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99c7af87b19b47865f0f5d6e76d4103e01b0729ec0c31a6a3f9c2ea4771a4962"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d4d39b17359d22f2fe695b99af8d3920c7c0e3d9e62a99a8b59235547a6df36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f479e0c9cd718a9c7a5b787884deacfb5136e25dce5762d8ca91e8087ea1315b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d78b383fa96af3ceea3d74c5bad2d67a06e37a936e601ef9e64e3558b01d4be"
    sha256 cellar: :any_skip_relocation, ventura:        "b6cdc0c30b30c04e4d689e9855429b5d3ea1247d6417ed9331c47d16aee4ce19"
    sha256 cellar: :any_skip_relocation, monterey:       "d55e9b90f70b19a61928efe53a1d390f01d4568f226446e59f2f8c47dca7ece9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e61378d60f64903a9ed472287c6d019bce3b9e95a97eb01bb5780d582ef12f3"
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