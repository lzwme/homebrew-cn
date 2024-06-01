class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.6.0.tar.gz"
  sha256 "6e4b7c66454848e40687a55a31f7a1dfccf6ab45cda04889f6058b4b82ad1701"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc1179e7f6cda61aae37dc4dcee4ca25f7bbc0d962bab5401aba6364381a2cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4111d9ed190b4903cccd839e1202f768f364030b15c358d399ffb4dac814649a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "164b83e4a787a95df7a12dfd7b99174aa510d3b887677cba16768eff4eb74fdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d3dc480fbbaa44d5297ba19293c24edc9fa06ae1f11ae389520b4926118c203"
    sha256 cellar: :any_skip_relocation, ventura:        "d14f0472dc94f122eda0a9c6210a04877e0172c380fe5add4e60de81b60b3f00"
    sha256 cellar: :any_skip_relocation, monterey:       "1694f0602eabd701de085ef57bea41bf5fdb4c06dca95e2a859c9fa0476e04c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d55cc1a3a60628c4ec0137b067fa7ee2bae93631e47dcf0474295e4f09f8e2c"
  end

  depends_on "go" => :build

  def install
    # https:github.comcloudfoundrybosh-cliblobmastercitasksbuild.sh#L23-L24
    inreplace "cmdversion.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath"jobsbrew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}bosh-cli --version")
  end
end