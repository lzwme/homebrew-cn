class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.8.tar.gz"
  sha256 "a1f4e95a418efd463cf3dab65a2f108338930ae9ffe8e88145471b7573c7b8a7"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54941c1d5ad33573ce0bf8fc6a7b8907efb0782ae88a32b1887aaa02d843dfea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "669c0ca739532ccf579e5aa8903b4e1f121303bb578fa194bcc3e8bae98c42d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "854a4eca45c7856ed23fdcb09edeaddd6ab0763090c0d8508017f4b54e866607"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f6036c59d2d9ba58d589322ab7aac22d9ac1bed77e7c0f2f01ec69801e2f48"
    sha256 cellar: :any_skip_relocation, ventura:       "270523ad83614f6e6adda3656cd74d3e5ca38ed586b38213a24daa870102b193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec07f81afc0f22956dfc0541b3b948227f1caf4293cc47a22819fe6968ba046c"
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