class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.17.tar.gz"
  sha256 "5459d053cd626f9202cad5aee98c48a7c2eb61487d544e6a64a4af9a276b3199"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e83d3d8ea6904698868877f72f406a1d2025412cfb415c1609d6906a7758c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e83d3d8ea6904698868877f72f406a1d2025412cfb415c1609d6906a7758c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e83d3d8ea6904698868877f72f406a1d2025412cfb415c1609d6906a7758c07"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c0da768edff93c3fe62dc0377d94d7892e48b88439c84594fa06355ac7ad27"
    sha256 cellar: :any_skip_relocation, ventura:       "77c0da768edff93c3fe62dc0377d94d7892e48b88439c84594fa06355ac7ad27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f857285689dfc7ae2b79c9f1c7cb2b468bbdffa61bc7cdbb2284e28f0c38f8"
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