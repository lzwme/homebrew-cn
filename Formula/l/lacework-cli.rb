class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.29.1",
      revision: "f56b9add8ddafabe501c7d1bb93f3270aa2d7968"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aecbbee3507220dd8adc87fe36260bab5f6b348af676531085656c7e6b2a697a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb52840d89e8a0bc7d27695e4220cf74f725ba2880a95a8ce9f5ff101fc2cef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e044991cdca7a29b8585561d7df83dd7bdadbc346277e6a0f8584c6cb45f45b"
    sha256 cellar: :any_skip_relocation, ventura:        "b64bde3f4af9686c2ae27f48000b1b5aa77fb89d77f9a1d111c7e0c8eb02cbef"
    sha256 cellar: :any_skip_relocation, monterey:       "012a3e83ad835390047e67d3404992d66cce4aa6fc14bc35b3e5d287a440a30e"
    sha256 cellar: :any_skip_relocation, big_sur:        "df07f7aa613ed4216bb65b8fc3d4cb01b455349a04526f28f0b7468a0ba293f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac4ba0729655558446aa30d0bb04cd2205234339facdd7fee19eb930e7b010e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end