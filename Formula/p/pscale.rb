class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.268.0.tar.gz"
  sha256 "23268f9cbcd01a6143a1fe04338060611131226e84e14fa4d5aff2e99a7c902a"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31549de1a746da1a371a31705491ac522348f5209c7a89bb6ddfe5d7d73fb217"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a9d74cb49d1688d9228a59eec20e080df282070b84179d1999232253edd3b91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "809d86042b9af324233a9b32a7c78109aaa9e86d80f695f285e986a3f36b4489"
    sha256 cellar: :any_skip_relocation, sonoma:        "9637930cb8b1ae24631afc9d3ecbf5c74e2e2ecae84013a360661ca88997d862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac962160478d093b63e0abbf799afb3659ea93be9db168379038f330541a491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6adf99e186dfe286f4332d7021e383d880327202832248154934281ce7e398"
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