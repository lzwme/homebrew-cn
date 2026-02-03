class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghfast.top/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.19.tar.gz"
  sha256 "e0a52f67d0bf69fca2da42e9c91e999dae5375010ce1ab8ace0d2629b1610d14"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d989301f7f410a99885bfc8d5e5b8773f8c56c0c3f5ec5fbd1200ba8bc38e542"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3543ff6aae43bc13fda553b2ead0357655e0d51ffc6f92d40dad001e2db1acbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af5002f59008757bd845ad6d15e4e5a1415d213444ac150c547a0aa6374a116"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf15cffee86be7269d24114440156541f22981320298d0375bd3f6877220a7fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084324bbc99c1b3906bd0eca8794245aee8aae68c97a3834138cd19a6efde719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efb2ab4c191cdcdb907014570f0db4974069826035ae107915ad5c2c5d454550"
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