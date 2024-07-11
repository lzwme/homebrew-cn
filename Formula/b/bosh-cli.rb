class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.6.2.tar.gz"
  sha256 "9c3c95fad7ae8ce52f31e4d52d914f2fb9be0c298824bdc17ff81a6d1653fb53"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2201e3c845a5f5e99b5c36b34bca1883d8c3bc6c686b75246c62ec4d0c871179"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a23ba334801452105c1377e9671777fb1254fdef9744771e06c52e2e82ad1e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2ff92eab4c793fa004fe22285bc5382ce11da89f58e2a9179784f81b1bd965"
    sha256 cellar: :any_skip_relocation, sonoma:         "255ce1fd5c51e8b7c4110bd975afbc459753ac4a37deba809bc68e2c54202223"
    sha256 cellar: :any_skip_relocation, ventura:        "2809b5276c402e7d5f7072a7f856c8211871e63fdf3c2258574590eafdaf1b71"
    sha256 cellar: :any_skip_relocation, monterey:       "ed51b85a40b5608f0a0056f2644bbfb6d6edf3977fa080252ef9da3faccdbdab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3a9c3edc8b24414f76b94b489d8eaee5b2a33e1237029d5fcdc01458abf961"
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