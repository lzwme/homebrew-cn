class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.51.tar.gz"
  sha256 "fc52f48342cf941bac9eb9406e46931a96ac2bc205c02e6635026bcb1b715efd"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "028e174b0c2899ab79e2a54b13d4ddd6e39e1c5bd4a05eebfd2e0091831b7e22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbe3285e16a2f3b9836fe80864c489c94ff84a0e0fadbfc7a44e176646da63c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bd8e9ab7737581a90dadfef666d85ff39834403ebfed6ae79091eff700cf436"
    sha256 cellar: :any_skip_relocation, sonoma:         "da6b502d9bec17443b8b4595c2d9af7c93f11b79f24fa09f1cc0bca5df34c969"
    sha256 cellar: :any_skip_relocation, ventura:        "f1c503a77f2dbad4bf1bac495fbde38ab1de2519410f2f387902c7da7ccbd47a"
    sha256 cellar: :any_skip_relocation, monterey:       "8228aa86a016ab864f1e19a48b8e340b0a309f1252a3d9a585fbbdc16560b8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8a5a817a835bf3d80d5c2ed9e21d58b714809fc1c37066bf263f7429203c77"
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