class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.17.tar.gz"
  sha256 "dd9846a14d30cae924a31fb4a715afc3cfcb78ba16e65e82eb8c52540790e4f0"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f79241f5ddb660819d0c4cc3f30cee3b216256d93b3b521e52a17d3b52c9fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f79241f5ddb660819d0c4cc3f30cee3b216256d93b3b521e52a17d3b52c9fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f79241f5ddb660819d0c4cc3f30cee3b216256d93b3b521e52a17d3b52c9fc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "521b9c615e9dec36c91d92f0168bb17add7e38f3e07c3e771e59d99059098d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b36ecbbaebf46b75bbb81ac995c9d942840ba2ff422b2a4b8ca73e84e70bae7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad7cb241e192c5a93f55281015ef1a66595c0b2c33d2d752b53f84db439a0f0"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end