class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.62.0.tar.gz"
  sha256 "da720acbd08b51463477eb667b34122082d4c4c2983a7a80510a8724967a5bb6"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7db0de9bdcf6ad5de8e3044e9b026633c5ce0a9e403fec48e2e2d01dd7f87c13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06b918e5073dfda86153e3a59c4e01098a217e6538b9fe9b5e0877e4eb58eebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68b206fee10cc12d72e7c833d0a0670ffe4c98b1a9aba0089f8dbbe89e561b23"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e40c989bcb82fc84d53efb1ffd487b2bfab6c24a6b9bd7d90f374dc18384b8e"
    sha256 cellar: :any_skip_relocation, ventura:        "3ed47cc5b765598caa5ab79b01346c1ec11c8b07cb10741045dd39961050ed5a"
    sha256 cellar: :any_skip_relocation, monterey:       "03cbff22e18a3fd506126c2eb7293b977785bdcf3905fcca116ee7fbe1f06539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b468f5883f22d0c766785216dfa24114ce8bb68b89a7a7983bf4635b1ffefb"
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