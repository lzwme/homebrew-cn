class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.68.tar.gz"
  sha256 "b615559e8cee659bc418a0cd3b74e07f9c4c940776a7388e32b6947fa3a880e5"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11cf783f5433a6f0984522f17cdfdcd00fb8604371664f20331315553cd940b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9e24c0e2dfb292cae66f1a5461beac3f4dd5f59c3011c5bc96c76f652ea574"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "975359e68ce103058684b41a42476f80104868e17d887bde01c793d07f9d136a"
    sha256 cellar: :any_skip_relocation, sonoma:        "704a3714f41803818af835dff9d54b070e9c4343757a496ae4f48745417c48a2"
    sha256 cellar: :any_skip_relocation, ventura:       "123e55039718423b662c9f87e616f145945fc4bd03e08479da4f10e37d0528e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d81c10ec7d502326806929648424c3a7410c0fefc90c2e7370ef2aa67783c9"
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