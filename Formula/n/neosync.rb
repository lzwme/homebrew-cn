class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.31.tar.gz"
  sha256 "65a54cd8bf71fe922455731c1f1e310cf6348ed22dbaebb1227d38a11b14b457"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "662a11c1decdfd929607750104d1c69f6fb556913e4aacdd70c2bbc229b07e4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2c1dab57419dd2900d4ee56a82a5cb5fb8b3772c8459cf9ce985362ad87f9fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e4c87d721b6e9b3eff1ca142e323e3355a7b0534c875a8f251d08c1615c6fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8d374389228128ad2c6552a83c4b0a940bbd31f5014241a2821f917c5d1ff80"
    sha256 cellar: :any_skip_relocation, ventura:        "5f56141ad11c981dd609e9fdd5a76c63f427c2b36c84d865b77b81cfeb7a0195"
    sha256 cellar: :any_skip_relocation, monterey:       "05c159e3bd707021f511fabfacf6236d801d02043ddfe318d06ce1eb8cdea56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e61fce73f5f38844b89019b5d9068b78f0c26b8f960527005ff1079f725cf12e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end