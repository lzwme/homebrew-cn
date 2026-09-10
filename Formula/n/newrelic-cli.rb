class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.14.tar.gz"
  sha256 "c246355f6340b7ca94ef95e960ac469e866f1f145f55d8d67cbc674cf583ccd9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41587d35d75b94c0606e35ffca217a239d3dc4688fda5b8cf77caf0bb3985cbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed269b4a365e827311347a0ecbcdca1c8d8841d058d1ee4bfdea469eb57488a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "568ca20246ba2137c40d6670b5c464a1dc8769a4b77dce198a952f8a5036d9a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3486a3d862aa225f3c22d220f27f13bc333bc814bff9883582f5d64830c332b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa9ab5ce9c64e95d4325e507514b1ace5be87436880d9c7f8566dafaf075c65"
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