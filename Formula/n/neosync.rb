class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.3.tar.gz"
  sha256 "e243b720d747c1b959f090a60ab02bad94b11511b9e55d546f56cd1f9000b13f"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13186de7e4bb2f7f7dbf3238dade54c014674fca24471d4886ccebcc478b31e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13186de7e4bb2f7f7dbf3238dade54c014674fca24471d4886ccebcc478b31e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13186de7e4bb2f7f7dbf3238dade54c014674fca24471d4886ccebcc478b31e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "60072151d4dac0620842fd1981509fd8b9a6e9ab8557ec6cc080a3dccc207d78"
    sha256 cellar: :any_skip_relocation, ventura:       "60072151d4dac0620842fd1981509fd8b9a6e9ab8557ec6cc080a3dccc207d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1a2e8b9ed88a69cf75e45a9a09a0499572be021a29e6841e930d7f3f07688d"
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