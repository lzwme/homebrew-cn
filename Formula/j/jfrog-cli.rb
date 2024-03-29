class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.55.0.tar.gz"
  sha256 "66f1f4a766ee5aca6a277c693480bead84b0d66288a7fdeb8ff41de43e545a99"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fde2d566d58facc20a5a5ad1bf43b67b24ddee9839fc168e613f50c5c77ed413"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfb1cfef783b2c1c63cdf3c3eb1a03903148bb0ce524b620decdfbea636e68cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93e992a9d30c1c7d659749d1e1734714aa860fc9d408858df5fa70981bb8fcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "27e4b5f9fe4ddbdbbc747e1b3c117b324b49ed7832fe4abb2470ac4876f2ac65"
    sha256 cellar: :any_skip_relocation, ventura:        "6062d9b6921c1edf15b53a1a647c6c88d6849e2bf963b2fb0e3f634777055ce6"
    sha256 cellar: :any_skip_relocation, monterey:       "f58903d0fb90509acd4f36a982435c682dc446a5a8bf42400d5e68d0131a8024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf2e6aa35b791e1eca27bbf4f3c1c72e9a562e65896c0bc7dc22b1683cb887f"
  end

  depends_on "go" => :build

  # upstream patch PR to support go1.22 build, https:github.comjfrogjfrog-clipull2447
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches636ea31jfrog-clijfrog-cli-2.55.0-go-mod.patch"
    sha256 "9ca953ddabb0e306fe3736af334c984b9aa4ffd1e2c9d2caed54ce5d621ea327"
  end

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