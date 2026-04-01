class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.280.0.tar.gz"
  sha256 "16e85050dc0c3da1853245cb9f00c46bdba4fc3275ee0edfb3f260b05b399a0f"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4e28136754e2e36ec95bc2b3637508b70fb45bb80a1d8ee4d2f8f4b3298d330"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7880aadcfb0d1778b89054b5584307473248793e3aeb4712bd15745a24b7cf40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d22d92a8f6b52aef6cafd433b3219e3eb50516d2f3ab50113095fb8f7dd2a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4075dd3e48f53526e3e0f910f90dd1a03785ede234f37cd719f416dc6a8411df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbb22a2a589253075f6c86bd5d2851a2214b999d63e3f5fd1c4cd6141e001752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3aca3ceeace13c15a2f59d4e32cd4033469a9f55b4d82ac5d28e6c3c9efcda2"
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