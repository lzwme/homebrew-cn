class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.97.8.tar.gz"
  sha256 "327c619da6fc268532b1ba1b236a12c2af05ee846aa79ebcd35058e1f469a6d3"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60cf62c7f5ef45b8fbe3535c7e043e4eea7a7610927bfb3efc16d8ef135cb74f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55775f13e5f58cefcae17622b5f885a5b4bfe25ccdc8ee28a27fe64e7805db5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e960b9874125d5d0945189f5eada14f3d5ba6e6147d2044aea307f106d80fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a127e88b1fead47607fdd4a6108d61d1e29afb17e6f50f0ccd7c74de418cf25"
    sha256 cellar: :any_skip_relocation, ventura:       "e27a1a48ed888efb7640f78c38072f365d7422f6f3f787f12b51d36c0b2b3307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb45746f795be3d088f72566cfb5582bb38f6d150377959a785a775f3a4ee99f"
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