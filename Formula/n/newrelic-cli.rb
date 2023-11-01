class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "ce6b93cada50dea52eeb8dffaa1f9ddebe7eebca447221ddacf019add76536f9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "213283d8871add1646caa5482a8eff207e6d9e0ea84db3cce3a14f72fad11751"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a8062626e6c1ba934d58666816b47b57b50b4555fd5ace1c200114e0b63d27a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52964b42581590b172d51d848dddc823461a4349e8d7fdb2b13de557ec334867"
    sha256 cellar: :any_skip_relocation, sonoma:         "a87269ca70faedde7bace17d7f79a5b496f654e291d219be90f8b0914a9c776f"
    sha256 cellar: :any_skip_relocation, ventura:        "2a3d4aaecfdc8abdab48cb30269d4a3f360be3a9bd7b6b54490d3f06fe5dfcf2"
    sha256 cellar: :any_skip_relocation, monterey:       "93c2b79cb561db2270719c6caf74fba3586868d8a55756918b881d32b0d33ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb073266373de84aed0a1d3552f957ebfb3d3b966ee46c92ed344a4ef8e69d64"
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