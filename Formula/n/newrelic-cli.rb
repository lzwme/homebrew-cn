class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.98.2.tar.gz"
  sha256 "383bf85ba72668538c780c3c50d7009cfe186b9ea13ec71dacf808d511b65e95"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d53a47408781b4614ecdf0d4653b7b57bc0cee8da59aa2c55a8441cc0d74b2a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e8ffad24460e35c2f82cc2b2845d5dc0911a4e95efec56f6f2dd9daf667a8dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6672c2abaf574bee3d7b687faf20c12422ca4edc9e342f4e6766b9d73655a9aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1676e29e313c7eaa8eb6ed7ff333fd65751ed516b72e0589963f510d80b3e3e3"
    sha256 cellar: :any_skip_relocation, ventura:       "a7ef8b15aed2662d76360b91f99869ae4f3cc8ba2afb021364ca9f29699f850b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "385f4e4d47b0b4f4b89e0ad85c81e2586a3124f15424798b36f2031ec24401a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fed705f119aa4f53a5132b21657eb064ec8367b62a9904708243a95dc8e3791c"
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