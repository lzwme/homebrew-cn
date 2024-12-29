class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.8.6.tar.gz"
  sha256 "283755ff763bfa6bd7be458b59661e7501b6dc5f4f5e5020b110633f50e2ef3a"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f85dc01ec07116413396fd77650622d9e1ebe0493d5aeceb825ef884ba7bc7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f85dc01ec07116413396fd77650622d9e1ebe0493d5aeceb825ef884ba7bc7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f85dc01ec07116413396fd77650622d9e1ebe0493d5aeceb825ef884ba7bc7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d72afe15c5e06eb19856004f95fbb27a6a43a54533024e999750cad9b16174"
    sha256 cellar: :any_skip_relocation, ventura:       "e4d72afe15c5e06eb19856004f95fbb27a6a43a54533024e999750cad9b16174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c58fa692d2fe208777435e50cfc07410b9be398271fd14d1745cd23c43deda"
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