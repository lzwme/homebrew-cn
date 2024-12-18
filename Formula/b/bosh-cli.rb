class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https:bosh.iodocscli-v2"
  url "https:github.comcloudfoundrybosh-cliarchiverefstagsv7.8.5.tar.gz"
  sha256 "bd259dc8e8dbd1db87b55a417c5cb653222d5b16c11d06062c65331724809e4b"
  license "Apache-2.0"
  head "https:github.comcloudfoundrybosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18f1a23bcd2195e7d0c9d344c810a7619e257ce13d05e1d781f2dbec56379ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18f1a23bcd2195e7d0c9d344c810a7619e257ce13d05e1d781f2dbec56379ed5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18f1a23bcd2195e7d0c9d344c810a7619e257ce13d05e1d781f2dbec56379ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "92a52ea36908047988ea550db13225efd835d6785f309e99640cf692429afddc"
    sha256 cellar: :any_skip_relocation, ventura:       "92a52ea36908047988ea550db13225efd835d6785f309e99640cf692429afddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16c9c71210c193a285bced0e394da0aec2a37ccce2e425b741032cf48886799"
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