class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.8.3.tar.gz"
  sha256 "2c7034048e8f056c9304036dcbdf658fcb81d80bbf32eeebf69a15a1ef6666bb"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96f0e2aa024b069aebe8f23c0c63de0f04471384bd06d83e9a036ea2bb68aa86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96f0e2aa024b069aebe8f23c0c63de0f04471384bd06d83e9a036ea2bb68aa86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96f0e2aa024b069aebe8f23c0c63de0f04471384bd06d83e9a036ea2bb68aa86"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d2a8b62719a7bbdbd3185f40e27bf1dbe31e61f6769f3a443a31a90b54bc46"
    sha256 cellar: :any_skip_relocation, ventura:       "b4d2a8b62719a7bbdbd3185f40e27bf1dbe31e61f6769f3a443a31a90b54bc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6befa8c136cc3b33eb8d35265ea3beb3e2444c2d03fb33c227539b513b8042b9"
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