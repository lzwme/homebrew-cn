class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.8.0.tar.gz"
  sha256 "e1fff48200497ee5fc1088518249808043981694cb8671323735cd1dd009b107"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6c6bef16272db8b90567993770c2edbb935aac4ba6c8a5b76c8ca8645d029c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a6c6bef16272db8b90567993770c2edbb935aac4ba6c8a5b76c8ca8645d029c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a6c6bef16272db8b90567993770c2edbb935aac4ba6c8a5b76c8ca8645d029c"
    sha256 cellar: :any_skip_relocation, sonoma:        "63a2eccb8499cfbaee850f6ff38eb2345b217c0317dc7fae0791407853ed7625"
    sha256 cellar: :any_skip_relocation, ventura:       "63a2eccb8499cfbaee850f6ff38eb2345b217c0317dc7fae0791407853ed7625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "079dfaf2cb01ca799fba42f9eec8caef5b921fe4d2b928c0e6da13949da8cc54"
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