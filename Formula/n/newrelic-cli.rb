class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.98.4.tar.gz"
  sha256 "1f3e82978a8c2fb362366d665047f919c1a6e7e7f93b60e256b85bc24e046da5"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ba4fe0cf3b5e247e383f8bc8fc7e9b4e05bce2c23a9da60e3b73394c682792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad06cf3b0fefb922ef1f646d3154bd37e6568b157d5cef938a7fb7972d717e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5776a8bad289858a9594e8340a4d6af74fc4d72aeea25bd131c18e2292bd846f"
    sha256 cellar: :any_skip_relocation, sonoma:        "12147a2aaa4f873df0d9b42bc99efd56069f5f71614f0624ae39a449b0280d35"
    sha256 cellar: :any_skip_relocation, ventura:       "a4ee118bef75ee12b6f80af59358aaca98a9414911d897136f5388dcd7e095bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89d06587c5fb2db2e68d3ba28bb236d93981d664152dd959d6c5cebad8896570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82eae2ebce90727ca33d58a74f1f086acfe4398e5931452b8efeb5a94e29c71e"
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