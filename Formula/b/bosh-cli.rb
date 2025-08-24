class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.10.tar.gz"
  sha256 "fa03c5ee647e4ba61f99c349e5c1dba65e2bfd7758bec1c98d58b184b469caed"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c13a5d5c26791cdc044e5d1f41b2bebc17549f142b91711ec20290eec3a0258e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13a5d5c26791cdc044e5d1f41b2bebc17549f142b91711ec20290eec3a0258e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c13a5d5c26791cdc044e5d1f41b2bebc17549f142b91711ec20290eec3a0258e"
    sha256 cellar: :any_skip_relocation, sonoma:        "95eec01ba924b1186d455081238377492d62690420d8210644706e1fb51ee575"
    sha256 cellar: :any_skip_relocation, ventura:       "95eec01ba924b1186d455081238377492d62690420d8210644706e1fb51ee575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5daffe335a84c80a91abe78baab7ca0f6ce96928047fb3a218b1e42cc4a7ebe4"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end