class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https:www.jfrog.comconfluencedisplayCLIJFrog+CLI"
  url "https:github.comjfrogjfrog-cliarchiverefstagsv2.63.0.tar.gz"
  sha256 "8e25a30482101099444d3b0acf6f5a93e3a803d0a5b0932ec067260db41d9983"
  license "Apache-2.0"
  head "https:github.comjfrogjfrog-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e0600324d16284c7661291c8152fb3b121ee48681fb52a160541c64931f022a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23426564fc999f37272e3fc2b92651b36d15870a5b636739fa05b85f71499228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf527809b9d391a7fbd2899653765646ac2b417a33a2624ca61d1af65ee2a0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad5779ec6a9f918046e44ccf46acca47c8155e5206ee3de1d2bbb06178bcc8d2"
    sha256 cellar: :any_skip_relocation, ventura:        "7594bb83b3bac66c6bae5ea28e4576440a8175ceb3134c02ab74ffa83ecf733f"
    sha256 cellar: :any_skip_relocation, monterey:       "16fed71552afcb5c31300b2d021da62ab7d1a594f1a41c9772bf905f9eff91fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e58855eb522418f16576418750295dbab7ed68758231c5ea50bb562d3eca7e8"
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