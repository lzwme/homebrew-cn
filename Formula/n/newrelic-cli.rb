class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.6.tar.gz"
  sha256 "a4b486f35038cc469ba9dc7c2327b47eea800f18d7cd4271234065bede665fca"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165a23b9cc79fd28389698d3f7b3903ffe49a367dd1812bb9d3a5ce3d98be354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe6505fc01409bd84cc9c0b41b17769cac10f09648a9e6b0082be86ca8429992"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a30d3d435370d51d1c191b237f1ff4b874728c47ca3fa953c87d30d1653e04b"
    sha256 cellar: :any_skip_relocation, sonoma:        "586cab648df953af7c6c1d072f2bd321b1ab9b3109627e436c65d5cee4c65b8d"
    sha256 cellar: :any_skip_relocation, ventura:       "7335073622c27dcb6aa22b63f4b66dc645f3d589e3998dfaab8745c1eb698c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d16a3f10806838e95dfac915a14055869a0627d08bdfe98660d62e7ec7154b"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin#{OS.kernel_name.downcase}newrelic"

    generate_completions_from_executable(bin"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}newrelic version 2>&1")
  end
end