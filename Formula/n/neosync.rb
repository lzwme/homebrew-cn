class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.76.tar.gz"
  sha256 "bf83b35af9e27eba0e1bb9e0830f2541cb2f53bf8cd9296b695165e4e4649aae"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902e0c84bd1fb5371467725c7bdd01a6a9f00ffab4ae2d0b05e7b1f06a0cf16d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "055fb8fb3009ae7e158a75e804302e9bc9113b1c6e42bef12fdf12266cf83920"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7155a40ed4e4550e81617198876ab241baea898cc0e8b57d7c26963f60f51d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8a238515d3b274f5b6ca101d75ae7aa9f30fd6ca69472fd621d0bb8306b65da"
    sha256 cellar: :any_skip_relocation, ventura:       "f5f9ec8c5f928df3d9166dfc462d5c4408ffa4a807c9c09a62e24ddeac3c3da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12d77ac32dbfc7a152f7606b00ee91dbca08fbc0001548e38dde2418984303e"
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