class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.83.3.tar.gz"
  sha256 "6b6525c1960c8c82c5c6d9db6ce01505f6aeaf10e775e7901b7b4d4b4a6787db"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb91b940797e893632011db42173d8e8c1f7ee1caaf004a07080beebb3124746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46850b547e0e76a18d70e742f852009119e074e09ec2bf7d080a01bfc5429b87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b199ba16e575e2aee2e3206eda638cfc91a12be61ddc164bfd15a6ef490bf14"
    sha256 cellar: :any_skip_relocation, sonoma:        "5409af41818b1f314c3b7d6e1339c620ff7578161b9ab8aca3b458bc56fa3164"
    sha256 cellar: :any_skip_relocation, ventura:       "414af49294fc193650f80ee6cbe8443176ff37410ae53965224cfd87cc3bf726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91449bd2f292c777b235fb122913a8cde1241c78e3362d5ffaada1cbe095fdb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end