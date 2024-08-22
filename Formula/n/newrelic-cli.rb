class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.3.tar.gz"
  sha256 "f4d99b7cf11e758906af7499fe5845ca19cb134ba8270a8dddba6eb8ed25f55b"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c4ee8ddbeef9c5fe3c145e5811ee008ca44d7767d314293f4b7ffafbbffc5e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8455b417f26094953383131283acc4a5a3e9fa94b854e03dfa9a04fdcdbda81d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed6a89748dfcea8bee557d3f1e16c40e6292849819b1bfbd551bd53673bb569"
    sha256 cellar: :any_skip_relocation, sonoma:         "367280bf90bcc63c166b6c52a2758f08c05620b3f1397e896e2d0ab7b12d5ce1"
    sha256 cellar: :any_skip_relocation, ventura:        "6c4390e8d06098ef08085fb09c13c731de2b3d92afa4fbf3f6e45fa921355c95"
    sha256 cellar: :any_skip_relocation, monterey:       "b6e0b790263378e2341a3ded47ee8b69e26049fc8232c11d34326f7335f64b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff55cac1e1fe33c31b71533bb3775c6fc873847d085df790f260db9e3a63f67"
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