class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.103.3.tar.gz"
  sha256 "73dc057185e5cad0d4704bcfdb4cdd0111f002413fdbf95ec541b3710479e9e5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbdf74cf92d9f3a46a2af4a56018447afa7326c0dd44b75fb105e3f6f4e86c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f224a5f37b5b6f968fc5f9643641c881ece95104bbf33569eecfb6edfbf74ac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "072ad969eac8d94166c77ca189412cf83df8daec906c2efb61299c650ce95976"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6e614144fe875a990a738573bc505b095693303300b0c7c8dd553dd993acc79"
    sha256 cellar: :any_skip_relocation, ventura:       "84ca0802457e7fe1ad003c9b239f617789d3787261632d6f4ee44267aa4bf9ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d50ba6e74e415f02aa16eccb6e5a16afebaa3db852f94732a1151770b1a579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ae4533b810dce16c6431782af173b260d77a7dc0ea5e13c64fd0777012128ff"
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