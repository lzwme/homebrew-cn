class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.93.5.tar.gz"
  sha256 "662ff367f955ec0823fc317be2af7f57fef123df096635e2b87d063d915b6cc4"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26425b00f04eb4ce232fa0b2140d6d8638a2eca4012518a439685ce5a519cf48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de75dbf79e1b85220366084f3e47f1350e6d37961f4c0345f3019e7b07493238"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcc6809220577f734f2d12a99c0fd2a3f8b4d8db8cd15b4d97cd40f3cf3b7b10"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1e51dec4f15391f5fcb92df62924b25d28e49af6ba980847752f3b6a0949fd7"
    sha256 cellar: :any_skip_relocation, ventura:        "98b55cf4f63360eecf00532001b4b876d4d9390a91e35447aac8ffd2f1a3a2e9"
    sha256 cellar: :any_skip_relocation, monterey:       "fb7b1316530506baff81e8bf18f092cd07781c3f64e10844a4177c919e1d16fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b879a3f275c8c0d363c21bcdb9939bbc4e05a956a31ef23973c886fb680e24"
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