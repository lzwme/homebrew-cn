class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.112.0.tar.gz"
  sha256 "6e19cd4fcb47c3441c58736dc3322fb1e35fba7d9ae4955a27943ed1450da8bb"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d507ff525d42d006c9d9f11a52bd852d271faf211dce748acb9fc3e17d01b50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d507ff525d42d006c9d9f11a52bd852d271faf211dce748acb9fc3e17d01b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d507ff525d42d006c9d9f11a52bd852d271faf211dce748acb9fc3e17d01b50"
    sha256 cellar: :any_skip_relocation, sonoma:        "202e10fcb5238cb9c0a602e3b01485ee4d9d439b7653d338c0bd1ce609af514d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b8b028f8fbfdbb84b066107aa97c7931272aba775c2bb8616373bfcebe38a9"
    sha256 cellar: :any,                 x86_64_linux:  "3c37524a720ee9c35e8f5824acff7ae8c776238ea172c7da087478e3d88aee01"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end