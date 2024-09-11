class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.67.0.tar.gz"
  sha256 "d896b843bcd9e19e07c64d158d4dfb73f1a11081fd47ccebc3c6c4a97430fd14"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c7fdfb4a634b56fa34c3b5ee14b489773720cef82af519b8351f993dccf38c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2466d2a9b4df2364c68ecab9f228e6df45aa93bf89aacc749cf27f99fcbda5d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2466d2a9b4df2364c68ecab9f228e6df45aa93bf89aacc749cf27f99fcbda5d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2466d2a9b4df2364c68ecab9f228e6df45aa93bf89aacc749cf27f99fcbda5d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0a4b20d1f6bceee488eb342629a8e857e0cb3ca7a9ecaeae5edf9466990cd43"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a4b20d1f6bceee488eb342629a8e857e0cb3ca7a9ecaeae5edf9466990cd43"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a4b20d1f6bceee488eb342629a8e857e0cb3ca7a9ecaeae5edf9466990cd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdcc3934aa3c5b4334c568da55d02c301ebcc2b22493410179d8c1b60911b2ef"
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