class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.9.3.tar.gz"
  sha256 "e876b71513db424b8607333b6c87ef4880225d68fc285e8260c6b2c93cdd376e"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4628193bc6444af1905d6415ae44e212303fc1285d207d8bea9baed0551386de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4628193bc6444af1905d6415ae44e212303fc1285d207d8bea9baed0551386de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4628193bc6444af1905d6415ae44e212303fc1285d207d8bea9baed0551386de"
    sha256 cellar: :any_skip_relocation, sonoma:        "53774c3322fa45478842a8614ca4f0004a0685dead6a396970951bd2baa99652"
    sha256 cellar: :any_skip_relocation, ventura:       "53774c3322fa45478842a8614ca4f0004a0685dead6a396970951bd2baa99652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770d70ca708ab7bce0ee6cdc497ae74026f7e82f6b518981b4569e197aaa8240"
  end

  depends_on "go" => :build

  def install
    # https:github.comcloudfoundrybosh-cliblobmastercitasksbuild.sh#L23-L24
    inreplace "cmdversion.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath"jobsbrew-test"

    assert_match version.to_s, shell_output("#{bin}bosh-cli --version")
  end
end