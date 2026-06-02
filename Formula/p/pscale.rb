class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.286.0.tar.gz"
  sha256 "d9d81857176c78104927d2d71385e7a7e42fcff06959e47634fd5b803dfaffde"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb6468ad11a5efb966a6dbfaa9d4a1bc65e61b270c6ddb3aacf2124752b8ab64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316cbc8a561143d9c77d45225640dd0c6b3bb0d1028d3017b74bf7771bb78559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d059af6c9af923c39d52cf824603f65c0bb639f55ea0ccfbea534b3ab4e0acba"
    sha256 cellar: :any_skip_relocation, sonoma:        "a649ccc00e99b9cecd21d9bea94f17012aac9560409e1c912bd27e92f83551aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e5150719d54f8764a130a822eabb75e107743a2f5fb3f30e04d0a8d9448a6d"
    sha256 cellar: :any,                 x86_64_linux:  "4a60b10cdff3656a63f87b73e713fe5e41128d9b8f037512bcf6748998465d2c"
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