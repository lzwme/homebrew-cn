class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.272.0.tar.gz"
  sha256 "50a429a5fb1404d034707215a4b41a8342a201e83728ed84e00974279a1bf2d1"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514e4962743a184c62e6f3a9e435dde5051dcf41a6f9b3329eb598b23953f7ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06e06ebd54ad52b90eef163a9c34aa19ec728419037a6227ad4fede8a0325e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1359ce5a0f2b6f0cae96148f2f4ce32bb9c308a99a3c7fd80e0e300f7af850d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "08efdfa04e58bd17041403816510cd565f2a3d4061db1fdcdcdd166f597201b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3dacf54856290df6037abf799663fce08573744b40fdab19160424413d7fd12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1a99348dc2392659c50f7d67c4659950d0cdb1f69482ab167760b530ceb71a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end