class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.11.tar.gz"
  sha256 "2fe5d1a39ad3575cff5711b970db2ac315a8769011632d609c10530b49828024"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44e96feca30865c743e432374c3b64259cb3d2ac6e4a84a85ba20c25a21a51bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c5c2289037d7c48936f6b062976c018aff59213509f653596eec2509f0583a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6135051dc90de6757a7d5ad3270344b2d50204b72d1671e5cdd0255660ec77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "165ade216976995afe18c9bfade92cabfade10f3ae4d69f8094949c91bddb615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2961f77c1bbcef4235edd394702419129f6f9f54bee6cb6206d33ed865ef0072"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end