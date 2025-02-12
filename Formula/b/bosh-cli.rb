class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.9.2.tar.gz"
  sha256 "17553db2e5e81ff09f07435ac6dac48089f213f7c132cb37b664e9fb92d51859"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c28f0128490f6a90ffd446c9c53a311ed987bc46b70067b21e15ee3f80caad13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c28f0128490f6a90ffd446c9c53a311ed987bc46b70067b21e15ee3f80caad13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c28f0128490f6a90ffd446c9c53a311ed987bc46b70067b21e15ee3f80caad13"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba6932ffbf32ffdd06630f37bf1eae6d556a4176b4cf005f1232ec5590184a4"
    sha256 cellar: :any_skip_relocation, ventura:       "fba6932ffbf32ffdd06630f37bf1eae6d556a4176b4cf005f1232ec5590184a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82ecec81ce92b4b39348d11191ce62dd5bdb6612b4d29acf9a3bd019e601502f"
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