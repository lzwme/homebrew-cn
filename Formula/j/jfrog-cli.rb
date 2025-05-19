class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.76.0.tar.gz"
  sha256 "41e1d876f8efaab7eab1fdf759edf0b6568c09988e3f4c30774f3825ac12f894"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7902cc111eff56eed4f055e65996c30a755575488be202ce639c5ed1fb8a7b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7902cc111eff56eed4f055e65996c30a755575488be202ce639c5ed1fb8a7b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7902cc111eff56eed4f055e65996c30a755575488be202ce639c5ed1fb8a7b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6405b4d996a05a9f5afe1ec440b4c6fa677368756479e930b84e19a9b782429"
    sha256 cellar: :any_skip_relocation, ventura:       "c6405b4d996a05a9f5afe1ec440b4c6fa677368756479e930b84e19a9b782429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7aa82a1c7de6a4dd46e45614932719c95f12dc59b7cfe12deb80d4ac8b8d26f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin"jf", "completion")
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