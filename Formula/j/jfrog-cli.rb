class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.72.2.tar.gz"
  sha256 "99811398c2a03c15f3bb524b45452226f19fc2e11cff7e32ba0f9b8f2bf2ea65"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29864ff2444b63e05b09b02396c6bbcb07ed23dfc02ddd060e7fd0289402f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29864ff2444b63e05b09b02396c6bbcb07ed23dfc02ddd060e7fd0289402f1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d29864ff2444b63e05b09b02396c6bbcb07ed23dfc02ddd060e7fd0289402f1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb4c0605350b08ddafd289d7baab01d1277c48f573750b290b6eccdee777ad96"
    sha256 cellar: :any_skip_relocation, ventura:       "eb4c0605350b08ddafd289d7baab01d1277c48f573750b290b6eccdee777ad96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "248fbeee1dc39bfc3bd93b6c3b6b03f440e3fb0dcd3704fb1b52be207d82619b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion", base_name: "jf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jf -v")
    assert_match version.to_s, shell_output("#{bin}jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}jf rt bp --dry-run --url=http:127.0.0.1 2>&1", 1)
    end
  end
end