class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.12.tar.gz"
  sha256 "911babbda19668562f281c2d3bd78da88e5f7560e1066479c87170d0ce4ec73a"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "193bbd134938318451231423c8b31bf7c5362b2cc5e1246f98bcd041d2b8740b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eec2b5dbf6ad9b7a9f8d06d1543a316a50b4bbc1049faa83efdafcef90db59c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecbd00426b3e207b7a5be5abe973ddae31bf903b66ac684037c908236d5523df"
    sha256 cellar: :any_skip_relocation, sonoma:        "31615e321a3f80f8a5e2476d0ad863d7fa5e16b0dca816972ddef12801dc1cbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e891277cc521c6c08e15a60085f4fd60cd15bc2722be0529bfb2797f28084a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65dc293a875f8b626bc24a06829893a49a6708cbe36dc21ed5c392ff3e1897b2"
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