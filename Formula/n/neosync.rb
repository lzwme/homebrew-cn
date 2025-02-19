class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.23.tar.gz"
  sha256 "63375395ff3a2b375f2636bb1c9857d8a71086678762853a888465368ef3228d"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "890b2e0500a23dda867b1b366ff64494bdee710fe550c4daa2a6fb538a3e5123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890b2e0500a23dda867b1b366ff64494bdee710fe550c4daa2a6fb538a3e5123"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "890b2e0500a23dda867b1b366ff64494bdee710fe550c4daa2a6fb538a3e5123"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5dd64ef1a7c077aee0115ae342f9e50107f2d788130496895d6d7314f237c06"
    sha256 cellar: :any_skip_relocation, ventura:       "e5dd64ef1a7c077aee0115ae342f9e50107f2d788130496895d6d7314f237c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f92f981304ff12267a818bc9210b5320abd63a19acc3d4ec22bb31d481888664"
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