class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.78.5.tar.gz"
  sha256 "428b3642e241e5ceb7558b12c9c0832510210525f3cf3bf7518370aecb51c994"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "310cc78e7347509f5e31415833aa8738c0250a75417ce4e329cab03da3b7e9de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5c53221076ade2d719f13f512369eddae60263cb7a94e0f4bb79b7f7a9f296c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d089450185e11d44894818b1cc32f2302f238e5265af214d0e1edd2003d2af"
    sha256 cellar: :any_skip_relocation, sonoma:         "03856a0797cff288afac0c966c2344a79b5bd1da07059b15058647ef044517b9"
    sha256 cellar: :any_skip_relocation, ventura:        "b4851c539137b02f94d9825c1c1868e941d62eb07cc440b0fb79702859c8a1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "54d1f6cb8f7354fc8d6dbcc98325f8f11a18239a594973124301d504602d3619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e816b026dfde3024831f3963998ccb1a210492b24032560c473c3cdb5042b4"
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