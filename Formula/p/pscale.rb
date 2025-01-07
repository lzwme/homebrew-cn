class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.219.0.tar.gz"
  sha256 "e82661a39da4336377d1f0d1ef1c1d785b7d3b2af38c0ab3fb0d718c651293cc"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67731a115336a8b0b10947d97ea484eb21a9fff260b8fa6a67d0ded0947c299e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74cfa09bca93ff614a22d5673dacb2ce7157fa9c78833508a8e5e0b854d389fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f725585480b9fd51a8d7973ab1a9806fda9dcb591a4df992648000bfd05acac5"
    sha256 cellar: :any_skip_relocation, sonoma:        "498f132121d76d21e8ad5a3a8118084156c7dc2e06c97a59569a7b5a3d7a200c"
    sha256 cellar: :any_skip_relocation, ventura:       "f899b991e81f7688bec1dbe55b54fe9697531e68c6140517f8967bd9fcb215f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f66ba2efdc181599133f077665855a73f36d16fce6a3ef6934e351930adefca3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdpscale"

    generate_completions_from_executable(bin"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}pscale org list 2>&1", 2)
  end
end