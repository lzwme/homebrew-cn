class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.2.tar.gz"
  sha256 "7880d18c6a022314a031219d48b22abe017097bfd1cc2c35c7bdab5dfc26b7d5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7764b48c323970e65917e47b4790bd6d56be2f6cb84d0f311dea6a57c574a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7e2949fe41cec7817d004228858f20351896116a644a2265ba27414a595aad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d41460ecb9a085fd726711298ef9d0bb37db222c80daaa5544e7c25ca6f1aed"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e421495aab6d1ba6ee6bf5c93c0c97e9cc0441ea80f09ebc04ddec57623bafa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e7db8130b7f67e165532a372878c822b7187c451dcd70a75060aa7f4aa4acf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5101c76e219c281edde76156276646435bb0db58f278c0c2ee8f1afd4ce17f9"
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