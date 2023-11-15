class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.76.2.tar.gz"
  sha256 "2797fe8567b5afdd45a52af9d4bfc53bb70f83403e8b5b38ef7838b9a7d1da22"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "844efbb8da6ca76834a510854bca5141285009242be4c13be0017132db10c8df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14b3da44b1c6a9cb5eed1f7f082ee860610750b63445559b34430ccba896fb90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4432079e2ddd8cf67a27293dedf16d5ce20474cb0ed9581224590c29d3143cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6abd1ffeb2fce399428724f61c10548059fd7eca56eb6018273769d8b817974"
    sha256 cellar: :any_skip_relocation, ventura:        "eb9100fcf002647780ae54b10940252f8ff8f974bbca21389ac66ad663ed8b62"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ae218ce1d1af987f0c7b0cf924c7223b499b92d242ecbb896a84eb0fa8c082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd9f2af882e74189d9e3bbe267fcd62057d9e7f2f3e33dff7b64cf61d348bc1"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end