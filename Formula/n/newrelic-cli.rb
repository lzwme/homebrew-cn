class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.89.0.tar.gz"
  sha256 "58b2b6c2b54124b348b63c1b73e3d345874029fcb525d706290f77c1e10821e7"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c2f17ebee0a5bad09b60a1538e9ed24ab1f4efbb515dff30095b3fd65e54500"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a41633adc730e398696c6cb7bb6af357714e9b3e3e7d5d5c2a207c0e40aba7f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "169871147983ac7621759d8eda5a8add58076e6d5307f41c673c3398e22ec46a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a72ebc92dae6897706e22722de98000180e459d1696e894ef318272838fe7db4"
    sha256 cellar: :any_skip_relocation, ventura:        "e593802b49bc2350df1f8ae134eba134e7fce80af5af8b0d93097c7b655e81ec"
    sha256 cellar: :any_skip_relocation, monterey:       "f418a923573314a6247307d051ddff13fd1c0bb56ad1fa005e10f574af145e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09a204cb4d73f9540bda3d9946cf0d7f4dbf63440d613f017cc06b9ec59d0dc2"
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