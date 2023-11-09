class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://ghproxy.com/https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "cfee5dbe99495fe40e7cb24a22afa109536c4c9312850bdda826241384cfed00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb1280cf323b18cd24b680021e7b2caf7ce7748f4b312750db1caea13dc9ce16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69945bfb956d43d463c631905637b18959eeae7c1f143528ce4402caa3fdef3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63e18428d193bdf20808dae111715eb12913a19bb683634729b2d509f24b4f21"
    sha256 cellar: :any_skip_relocation, sonoma:         "51c82083d421b479af310cb4f59e6da06794c8acd0347ca2423a84ab73193c79"
    sha256 cellar: :any_skip_relocation, ventura:        "29225e98f460a402604f2ea826f65ab837cb2520d7baf39f2d373b2b29718c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "0e2596a82320ad0617f123d786d08b1f7fada44ab3cbd04d818a010add93f466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd98de6c37391860596c35a66998e6da36b4ec0ef91bb68920fa7d6bbaca159e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion", base_name: "jf")
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