class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "94bdd0df39eedc18241e66ee33d886bc626cb21f8d74d382e0641fa28351ac76"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e64358adf23f17f92a89048a9cda5c0b2b82449f8d608688145d370a2d64e594"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739c20e752e2eb9476bb9e9a29d3610c6ea9f9a106945ca5c64d14f6ea0c33fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9b0c546046a912048728313f3441b18a3fec0b2c6be0abc4e1448d3edbcf64d"
    sha256 cellar: :any_skip_relocation, ventura:        "b55fc28868b1c7450b9bc7b36afe16c1f05416f1e029c7dfc6e55a02fb0db49b"
    sha256 cellar: :any_skip_relocation, monterey:       "f1c24705b7b657ab84fac53f606dce93059e084d49731ee33b4004db762134df"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce4b4fe78cc123ee6931c08ffcf5028ea5ca0fe230f6e65b771a98f720e4ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "633efafc070572663f94677a428d10cec65d02b5f092db9a3ccb35a37a811d78"
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