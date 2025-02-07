class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.9.1.tar.gz"
  sha256 "30706fc8ca1a3301535a1411f82b26b8ad4719c10f2cb280a791c4ebefb6652c"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e5d901e5b8594e5659c723d17f7bc166890583271f592aeeb74ecbdb7d86ed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e5d901e5b8594e5659c723d17f7bc166890583271f592aeeb74ecbdb7d86ed0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e5d901e5b8594e5659c723d17f7bc166890583271f592aeeb74ecbdb7d86ed0"
    sha256 cellar: :any_skip_relocation, sonoma:        "446a2767bc7aac9f392957b0f0f406e9a044d998acd0014ef8988afaeff10003"
    sha256 cellar: :any_skip_relocation, ventura:       "446a2767bc7aac9f392957b0f0f406e9a044d998acd0014ef8988afaeff10003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db17b0cfaee88c8961154b2620ecb12fda016376f481bdbf9ded6b85a4031231"
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