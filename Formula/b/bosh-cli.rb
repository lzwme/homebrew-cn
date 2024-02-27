class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.5.4.tar.gz"
  sha256 "f0122749fca05b4aaf95258533d718ed580b0d4914f23bc80993b20273e95733"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b0ce359e3978738c692aa21a295c5870b62f2a26d01405042457d08fd102c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e55f25580375d87376435708595f8b92685f70e2f8af60db959bd324fd04c09b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "186729f0978d1bf4cebb13da57d2ce8da79d659cff4e917568bb9c6a51fe5302"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3dde26f2e58a8b34981850edb78dcfd4958f50d79cff4a8e480e90e0634ae26"
    sha256 cellar: :any_skip_relocation, ventura:        "6c36ab807de5c5330970dc816a14185c74e3a733691391fb6bd56a67ccf4f71c"
    sha256 cellar: :any_skip_relocation, monterey:       "13597835a583dae8c8040b22450c54e3810fab1178a9d999d2c93e358800f06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060250ffb6f452df1f600da6eedfc576a28054f860bddc1ad298fb583df95976"
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