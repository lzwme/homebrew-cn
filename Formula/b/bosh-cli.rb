class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.9.6.tar.gz"
  sha256 "3749c85b61bccbd1aa78f111353e5ea5214000670669f16eba5e04da9604cd7f"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "636d40a832b2928217d3f24ba9acf3724a77c0ba4832fa7481ca380a2d4bc90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "636d40a832b2928217d3f24ba9acf3724a77c0ba4832fa7481ca380a2d4bc90c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "636d40a832b2928217d3f24ba9acf3724a77c0ba4832fa7481ca380a2d4bc90c"
    sha256 cellar: :any_skip_relocation, sonoma:        "256d625ffeb0fd44d4a2874741aa02d432f548bb6f3bf9b108fb3e69bf6ec967"
    sha256 cellar: :any_skip_relocation, ventura:       "256d625ffeb0fd44d4a2874741aa02d432f548bb6f3bf9b108fb3e69bf6ec967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41861cf1d8dc1ba43059369ec2ca3c97aa871bb24c0220e5d056009b2a285cd7"
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