class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.15.tar.gz"
  sha256 "27461ec214e6d3ffef5c5b7b471f61a9fef9e866248726f9450bb78abe7fa22e"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d5f451ac438be439e3dba7ccb5e8d621b40cd661d52d9d200f4ceb6c5e5f77a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d5f451ac438be439e3dba7ccb5e8d621b40cd661d52d9d200f4ceb6c5e5f77a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d5f451ac438be439e3dba7ccb5e8d621b40cd661d52d9d200f4ceb6c5e5f77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "388b7c2711bac3adb49ddc6e382f82f869f949f3bb11a3bf0c5e3038a396238e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "146f6a1da2778e58c8b795fa02f75a005a26ddaf754903d56a9422dcb1c29b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f479ba67f7ccb20e0a75a9dadd7b0ea7993d0ce18bbdf8754269f49a06d3631"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end