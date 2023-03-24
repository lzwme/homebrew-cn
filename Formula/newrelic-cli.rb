class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.65.2.tar.gz"
  sha256 "0d85043f6fae33129ae022f868898f77909852cbe0fc27c5cd04517a5c64daa1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b94f242465a7042a2781471901b38be072b85504f9b2ed3e2288c5cf34c8315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786dd453afd1c0000533a08c8f3fd610522445ed7b2215fb23a127e52b625cee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e3b73f6e1ece08460688e4b4b95a2ddeb6a3fc7bc6cedbcdf3c5686f21dca8b"
    sha256 cellar: :any_skip_relocation, ventura:        "10c2267a52b889929058f08a9e0c4200f7010c0b5b9c687342d572399eb25366"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e900476ca3f5b2845a013d719d259fef839c92edf33faeb878e7a3ec530aa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "447550d7ccd831c59b05ae7653de2cc09f037859a577d9763cf0e9985c04cd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03a8e3b5c1ea585d23d71f7edc34a351405000773f2c317b59ca643c98ff1fb"
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