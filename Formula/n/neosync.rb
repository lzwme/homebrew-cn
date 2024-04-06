class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.5.tar.gz"
  sha256 "87dccae750de04082746cbe683e950aef7bae472ad591c021246daa6fbd018f6"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "597cbdc02a14ed29bfcde2f3a1da72366297040d700f1bc218eeb0edc674b1f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07554a296361dbe632c108fe5a416128e3129b6e56edd27e68e130a65f659fdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d97de671d756f62f45e3952b8b310d12f0aedcc58c48a90f55db6b931e2f36"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b802d717394d747a56d79e5bcf3872f413a8fe03ed73d0cbf5fd830f3400f2d"
    sha256 cellar: :any_skip_relocation, ventura:        "8480fb078bde444cbda4497d787f0b92aa8644841e2ece709503a7c1166e8fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "fe992302b7bdd41d952eaccd537c7298587b39952b4092d0ec5162243f404fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88823a10b9d3ae70aaf7c72ba789eb4399bd1224edd6f309565dcebf0988b612"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end