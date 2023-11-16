class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.76.3.tar.gz"
  sha256 "a4531827ff0b03bf797968ee2dbd3c70a615579e06a87ac4171fe7a21de6a716"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f6fd7ffcd2b213e8ee7829359ee6fd3afa7b3d79075d3fced904e89f63f0d4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c19410d39317369fc88df44c89b77bf4e5f03cabccecc5f73894d09c9afcad33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bdf276a9ba85117b1b9593512d67bd7d5c6b58fa2eb0e9183721eda49b71d8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f110b1ed601927f7aef444cbb3feec5740018ef9c6dc5fad19a9c7d214c7771"
    sha256 cellar: :any_skip_relocation, ventura:        "5972ba89914b4b6ea020eba7c957c2336d796e9960ae4742a3b09d2c1e1ac8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "c32f06c41b9f761bce76e85b76c23d9a5b838aa1083e8bee01e52e1459ea5cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f5147bdc3732ec95465ff4bb793ba4843432b6e50601f1016b3ef11995b0e87"
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