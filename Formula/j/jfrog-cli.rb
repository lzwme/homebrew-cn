class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.69.0.tar.gz"
  sha256 "aa701ab1ed84e1209dab7d884a8f0c8ed50de3edca1794e7abe27497af008fea"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59c33e87afc16de03dfa88d64107adb6176765761dd922d6c92fa26916ed2ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c33e87afc16de03dfa88d64107adb6176765761dd922d6c92fa26916ed2ae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59c33e87afc16de03dfa88d64107adb6176765761dd922d6c92fa26916ed2ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ca7d881181dbd01348423b3c8b82bc21879f4274a93abe8cfe41815195fec20"
    sha256 cellar: :any_skip_relocation, ventura:       "9ca7d881181dbd01348423b3c8b82bc21879f4274a93abe8cfe41815195fec20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac655c94937192a60a86b46e2fc2de77784d26cadf1ddba253dea9234cffe6b"
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