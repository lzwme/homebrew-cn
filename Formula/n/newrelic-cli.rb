class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https:github.comnewrelicnewrelic-cli"
  url "https:github.comnewrelicnewrelic-cliarchiverefstagsv0.94.3.tar.gz"
  sha256 "d2be02f96779d63ec632a067b28f2d8900afe4aa8c8895acb1c4ca3ada1afffe"
  license "Apache-2.0"
  head "https:github.comnewrelicnewrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b6d9c43fefae8e4e30284e582257bd59df9f5e7124154e04729e9752007795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cea246ac6a497674b3351055868d801303598b671ca8708b09ca0f4561096e51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db2814044356497bafe778cc9e9f90214d5de33c8870a4827eb2d776a30fe80d"
    sha256 cellar: :any_skip_relocation, sonoma:        "eef4c6251158f4d7baf89992917c840ada8b9f53aa3c72fc512b8194d93ba1b9"
    sha256 cellar: :any_skip_relocation, ventura:       "406f2e8e17fbd2f9890a6598398665c7b019991b113e9d23d4a98cfcb225c631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5972a75c291b64644b1acc8f3036ebf7b57a3683b348f9e02761418a1e8f205f"
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