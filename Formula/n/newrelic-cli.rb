class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "2513cf6f940555bbbb4d984ea00b772518434ce118edca72fc00a1b5deea9576"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3812e1b4e4505156bbbab421cd86692f2e781920c9e3e736b14e356792de355f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad82ccd18d1385501b145757adeff17c330d9ebb9328a29a2ff68a5b583ab909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c12736687b16d45a23f327edfc66d0769620c8f1608bb5113aa3f2a965d4989e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b39c19025ae5eeb65ccf4ac899c73cf8a99fbaa1c5b2b4675de4ad782c358389"
    sha256 cellar: :any_skip_relocation, ventura:        "6e799ce452652eac34a6af491e9fed5eb082cb857bfa6c2e5229a446e75566b6"
    sha256 cellar: :any_skip_relocation, monterey:       "69eeb625db1c71a8c5c4c27a90a7b7007e62aa9eabaabd3fe5c573c9e1c38b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed897967e8225d808eb241f6149cd174bc17cbfefbe31fa77a9787c6fec0bd41"
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