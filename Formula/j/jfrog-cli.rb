class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.52.7.tar.gz"
  sha256 "9b3814430ba84e34778e130a1f50ede4002cc76cdae9d08b07d55d763758ae57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "721513c40df5a79cc601649467eb712e93b706b9a6a4dc70daa9e67831ac0fa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274e7254f3172a34efe5d24913c059b61af6ae0213e5d9d2a7300a99d3552a5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4fcee37ee647d6948ec1f331c12f30fbe3530a5bcdadf889b4165ab7e995aca"
    sha256 cellar: :any_skip_relocation, sonoma:         "4194b4d6fbefe622233a1d426b650fae02ab2f540c012a53ac453afda1694ab4"
    sha256 cellar: :any_skip_relocation, ventura:        "4f7a00225daa3ff4dd256af1597e28dbba30efa7ee798377c15193b1c2571c63"
    sha256 cellar: :any_skip_relocation, monterey:       "3117a9b41533933530ce0fa32b8023931902d03a6d295f42d4ed1585a368de57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4982e16bfea3b8651b2b0863c496fd6042a99582d06aafce96ad0351d7fb0837"
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