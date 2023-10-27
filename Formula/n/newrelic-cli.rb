class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.73.6.tar.gz"
  sha256 "fcedea46e70e45188a4236c076bd2994503d3eb00da4498c9c7d0f8823b2a321"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56e0ea551bb837c17c904ac81a65aeeaba92f7c5409124468c52d8c2e2f2ad37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546f565f900ea8e1720743d20c439629658392916799ed8bfd5044ca0cbc2054"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3f57d9166e07b114eaef3e7d7fd6b312f5d091a64f366c148576044f6518111"
    sha256 cellar: :any_skip_relocation, sonoma:         "e51b09769a930607f2e21bc2b8228dbc32a47f20ec792dd166bc9d8aecfddf3c"
    sha256 cellar: :any_skip_relocation, ventura:        "096c4ca75e9e37ef12b0b67e06299f4503a23e44c84462f77f43d80c0e13636a"
    sha256 cellar: :any_skip_relocation, monterey:       "b497076e612a150afb00af6c4f34b89e43b57056c039dd701d6ece958ec5bc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "107fa94cb809f33f773807a6e46e9b6791067b24ce6b7e2e1a1b876d50e79539"
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