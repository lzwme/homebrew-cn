class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.59.0.tar.gz"
  sha256 "3186f8dcb9178fba8999f9a04fb0268ea02d00aeb9e690be29f991cdc8f33740"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8ac51e5b1a5ae0f4877d9d4d404e3a78af1d2a01bdcb95602839be47fcbb152"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdf863b82c43f0fe724a6f83ce01e89f0a2b47431d8fd4af375ed5316b57a616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301ac2959f5d784dc405fc46dfff69c21f9138fa9adbba1bc6ae50f73b254e93"
    sha256 cellar: :any_skip_relocation, sonoma:         "41972362d7572343b132a3e47c2e6e29e2036548bfe69ef22dec975c3eea41d2"
    sha256 cellar: :any_skip_relocation, ventura:        "5cfef06b6787bc9c3f6dadc648b83ceaa5f39c333708381e76ddaa3396bb94ca"
    sha256 cellar: :any_skip_relocation, monterey:       "947df4baa0575e820ab1596df70a1d8cb04bde84475edec0a62706b77b0b14c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6557f53662a663436dfd27e928bf2cc4a5bb063cb4da730dade649d006a6285"
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