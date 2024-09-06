class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.4.tar.gz"
  sha256 "0f1b14991532db6989aaa363da97780a0e2737473811b8c64a4e7e90cdbf1c2c"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb3758fd484207fbfcc1c892518fdd02edc81f04544ce5fb714d9d5637714b53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c867695a58c45d4d8730b59a3d09520ecbd2e005fba035f2e396bd84e78129b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e558d6ec8f00dca566cc7dc3fac821da94db1f135bfad6e6af527a474139d0ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "9623ed1366db3eebd9a11f302c1dc4dbe62d4c2fe51ab85d91901caedcd376b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a80cb5d5303fb3c752576ccc8f7f4dab52fe57c24ff5216eba35ca56ab68190e"
    sha256 cellar: :any_skip_relocation, monterey:       "d316791ec060fe2c173cf6296c5ed0a6d1a7d8a9c304ccd440feda1f4bd5ce4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90fb4ec0d6c94b11434558282f815990cbc4284926b06fef159edbd56227b12a"
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