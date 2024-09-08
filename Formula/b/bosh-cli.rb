class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.7.2.tar.gz"
  sha256 "9238a5d169717d731e7c10ea428e85b24094c63f37db1b94647dbc58e79610f0"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "432dd1ce8734f62338e02cf8e4e6530c99af811115a8161e0f20d66e0d10ad6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "432dd1ce8734f62338e02cf8e4e6530c99af811115a8161e0f20d66e0d10ad6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "432dd1ce8734f62338e02cf8e4e6530c99af811115a8161e0f20d66e0d10ad6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "47ee9b6bf747f2786730b769fcb04dde269ab80a77d490d35bf6779e89b1b9cd"
    sha256 cellar: :any_skip_relocation, ventura:        "47ee9b6bf747f2786730b769fcb04dde269ab80a77d490d35bf6779e89b1b9cd"
    sha256 cellar: :any_skip_relocation, monterey:       "47ee9b6bf747f2786730b769fcb04dde269ab80a77d490d35bf6779e89b1b9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da28e7692c75bd26e49c6088c196696845b192ae32cba15fff99a1c74ca07ff2"
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