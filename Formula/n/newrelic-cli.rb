class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.0.tar.gz"
  sha256 "9dec1c72fbe15fdf880119b1afdfb761968dac30cb1d883bece7973145275a86"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829c1c8742c2ffc853d8f921b89cb9e50389ec5ceb2a3fb68135965f77348b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47e657c1eb306a87dc815b2cf4152fcfa31437fee3d8d9bbd29e56c0129b248"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "061eff2fe7671524f1453d8e93a684ff22cdd9ae445cf588ffa22b305799a8a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d19ce4c3327d1387c9d7c51523f13c641dd00e8d8c8cfc716842cc54d337882d"
    sha256 cellar: :any_skip_relocation, ventura:       "1ea5c4c3ed64d6d707309123f5b2a6a4a4fa91f7308ff78f637080df67c592d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34fa71a0b49fcea34882ba62230314c4abc73d82b61d2c1a51016299e88946f0"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end