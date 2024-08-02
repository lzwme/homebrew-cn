class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.62.1.tar.gz"
  sha256 "4b76fdb7b0f4e11bcd383dfe6ac0b01747916f936227445bd916c97f6bd9b8ca"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53d9bf882e6f10a244b50a4359d92b08635b39699b46ff099301874dcdedcff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c22d8e7e7f79f529fe4e5e1df388c4151b2f5e9e3276bbcc9b0f996c1de2b66b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95aab17a5dbf4148e510e3dfed36f0554a2f6bd91eb24a7bd1cc70a9b8c756ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "79981fc34d126ba45ab1cf02d2ae544d4f5568bf3cd187eb4ed9afa82a7ffe9e"
    sha256 cellar: :any_skip_relocation, ventura:        "3c3a1f87c5f2c3db75a4ef4fd04204265a5e9141c3f9d7329878422baf967f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "a36cd82696c7bbca43e524e640450801d3da9372bccb0ec11f3d04a83d7997c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6fbd8a291054cc9512c97c55eb04e9572e6f5e68af1633a77628aa3e15b87d"
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