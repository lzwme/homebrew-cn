class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.35.tar.gz"
  sha256 "e90a09a9501ec97313d89d97f567fde9ca72a8daa335e6b643393305cd363183"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "513df7548e30f1fd0edefb1eab07320e65ebe7816968fb3b6c4c8f8e0603f4cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f88fa53bb7e23f3f7b9d658349aef988853106d1f18750c84a07bef4d42ff24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4598dc524909bdc615693fb742afafe17840aee9d0ea1beef287cd16c3af301"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1bfa7928f51b1b3dcee654b7fb1e886bdcc68735c6ba0d1fff3147e660f1618"
    sha256 cellar: :any_skip_relocation, ventura:        "26038fc27baedbc11c8cc3e44abdf561649d89583d79785f4006838bef1143c3"
    sha256 cellar: :any_skip_relocation, monterey:       "203492027a81838b34790e4aca53ee5ef79d45295d007c22f36598eaf671a471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2811ef6673af6d42eb1c4dd8550e9798355edd45e6c8f8c75eca470df6ccf595"
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