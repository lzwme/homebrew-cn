class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.65.0.tar.gz"
  sha256 "883b2621d3a67eddb55636e7dcf32074998928b16526f92893f504b87a069312"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7ff87e95ffb57e16c56d2ad31ac10dc16d5dd6aa6bef2b0ed8dc3e3e3cff8c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ff87e95ffb57e16c56d2ad31ac10dc16d5dd6aa6bef2b0ed8dc3e3e3cff8c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ff87e95ffb57e16c56d2ad31ac10dc16d5dd6aa6bef2b0ed8dc3e3e3cff8c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "194c27b6f370f72be312a077bcc08f6a7c53440a241c0710a2fb03f7d3acc747"
    sha256 cellar: :any_skip_relocation, ventura:        "194c27b6f370f72be312a077bcc08f6a7c53440a241c0710a2fb03f7d3acc747"
    sha256 cellar: :any_skip_relocation, monterey:       "194c27b6f370f72be312a077bcc08f6a7c53440a241c0710a2fb03f7d3acc747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f7fee38fe94da8d01a7c2c3d0f9d23cc0987797e489a4d997cc19cfdcbcc9d9"
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