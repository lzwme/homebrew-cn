class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://ghfast.top/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.105.0.tar.gz"
  sha256 "4a953545c1c22461b959f3c3ec83c7d1be18f512ac30feac47ebaad1f3c34ba4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "424ad85a84cebf766c2cee2725fcae63f46be97cb645a1e06a070a5421fc1352"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "424ad85a84cebf766c2cee2725fcae63f46be97cb645a1e06a070a5421fc1352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424ad85a84cebf766c2cee2725fcae63f46be97cb645a1e06a070a5421fc1352"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c0237e99edabdf4cc45215e4459c5fcdc155a0b807a1542306eb5f67372fd94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da93db11287be072e320da83d962617f4c01cffdbb362e35d9bd256f7a36eb4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133800c98c023ced16ca62485c499f20a9492f9df5dbd00b6aa6565c681f2a79"
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