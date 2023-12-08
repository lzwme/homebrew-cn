class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.76.4.tar.gz"
  sha256 "6e2e46b08920b2d49d1d3fe24ca297e8e57417a2f99f0beec08adc4cf20c58b3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5d3a9a5a416c2a09d568830aebbf14e58cd992c1c76876af2a1c5cf772f694b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d280a998ae82efb158b0d454ecb10a5dca91c60aeaf1fd9627438d82ed2fdcad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d117dad1e8fac1bf58b619a3670969b062a52bfd29479f988670a6fe697e480"
    sha256 cellar: :any_skip_relocation, sonoma:         "64421854370c7bf57f929f1aa4a6d49c3892275a94eedb63eb22efcddc66fe78"
    sha256 cellar: :any_skip_relocation, ventura:        "8d20154eb628ad3072fd87d852e94266e914c96512e9098290ed190b22b3de30"
    sha256 cellar: :any_skip_relocation, monterey:       "248f276ad02e83d63b4926447caf77565f9f9480b18fd0645354d214c5ff0385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "442efdab1b54a39c7fa76501cbcbe4b134aafc17321f0bd7be89abf54e696c19"
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