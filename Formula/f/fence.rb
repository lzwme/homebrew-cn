class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://ghfast.top/https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "d6e558e50ceda30c5514436d3ca5e6d3a2949f87e7ef66190b2be4b4e23f3c9e"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62123f7ac2126d0f32c88d5841d954ac470b42f5657002658b44a276db0a2608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62123f7ac2126d0f32c88d5841d954ac470b42f5657002658b44a276db0a2608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62123f7ac2126d0f32c88d5841d954ac470b42f5657002658b44a276db0a2608"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb2fc3bae1c65a3a98e902b06f9e9bf6dd0f4cf04a64fed2b0663c8053b029d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eff1cb028ef31450d8e743feca4fef26433ea1fdc45fc411ef92b258408be86e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c6380e3de6bdaecf4b51e0b7196f1501fee5a3f38ce629c18e3388469230cd6"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end