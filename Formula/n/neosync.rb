class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.53.tar.gz"
  sha256 "354f13bd2a10ad33900bf48cd6dfde47a238e31a3083dc95c9fc7084b48a0ac0"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbdc8b41a0b9af633ae9fc95283507f5132469da2e78ea7dfbd68059e3d4130c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c68f822514535ff4372fe5694922b20b1e43de9787a192804bc8ac8fa6de8977"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65c1e9831be30005834e522b1e627a8af74e6c8facc70b8f634a51a96e7c7aa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8afa7fa061747fda6da2713657b28230981ef98a8168efb9c43f3a7b44b1adb0"
    sha256 cellar: :any_skip_relocation, ventura:        "f471f92f5da7b8c93540f8df24c62e51c6b52b38441f1cded135c4c706edc984"
    sha256 cellar: :any_skip_relocation, monterey:       "30f0e336a203d607cbe838ac84e28e2f35e8b702deeb9722dec9ea700f1a290c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15d0d451c794783c826f2fa9c7761ed6403ed75162c9e3f80ab764220e0ba81"
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