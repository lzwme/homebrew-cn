class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.13.tar.gz"
  sha256 "750df65e576a91ffbc743e7893a48fec731b237783c79daf87dd23b6220a3f4d"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33124e239930c9a199c92971cd6010095eddc02aa58741d6bee25044f46404b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33124e239930c9a199c92971cd6010095eddc02aa58741d6bee25044f46404b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33124e239930c9a199c92971cd6010095eddc02aa58741d6bee25044f46404b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "66583b3e61bf177187ac75d292bf2099b1f00a01499fc472f6bf9017a770ee74"
    sha256 cellar: :any_skip_relocation, ventura:       "66583b3e61bf177187ac75d292bf2099b1f00a01499fc472f6bf9017a770ee74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1781a0a0aeb0bf06838a1dbd14b22e15587516b1165a393035e1675e907d7a"
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
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end