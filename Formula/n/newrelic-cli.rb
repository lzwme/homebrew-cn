class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.112.1.tar.gz"
  sha256 "5cc798d67157ecb9043eb0e2701407e2ad312a57d2d472a40bf34bf525316522"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "821afb0007be46fac6d94850bbdb1ac0957ff422971991a8f6ba76418b82706d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77570c9e4f0a50d556151c4c2c877459ce52b8164d7640e06f62039562ae378c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65357253c79f414a4b62001224977b960c751dbb5105648512bbfb3914161ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a44c3ce97ba7f3835ac49ebb96b4c9ef3267447dcf7de08fee6dcd19a835397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e446093332e23e42fbd844442e0947bd3a19b8ab0800f51de444e89ef165a9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "982d36b3f8790d6849b1e78be63699299a5adc3f6b7fcc8325aea918ba084aa8"
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