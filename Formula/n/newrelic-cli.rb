class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://ghproxy.com/https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.76.1.tar.gz"
  sha256 "2c4bcf6e80bb86b5861b372cdac991f57acf36bcec96e6791204aa1e3ea39042"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa58cea7d6dba63a3e2312890ba2bf0931b0cd8bca20f4ab6d32ec5b5e4c78d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ce8372c508a53fe0301916092573c914c7630c2c43adf804b70586b75a205b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7aff51939105ab288a646bfee7385a0f036f5d31fbb189e91359a6c9c1271ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c44220d25c9737bbf1f7849713e911ef53079e3853d023c3559c1251c8e61f6"
    sha256 cellar: :any_skip_relocation, ventura:        "a9b8e258e1235c65f794f41e206374e5a71abdb09f329dfe0f39ba68b903bd95"
    sha256 cellar: :any_skip_relocation, monterey:       "4d5b4f1582410157ea9db646de4c9e4a5e952a7248b58148c646d68dfa7452b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dbab3388ea7a73d5e6402aac179ca897962f56b85dbb82c40793aa3311dadef"
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