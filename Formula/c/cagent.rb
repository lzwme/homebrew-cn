class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "172c73f4aeae2ddf646314e9c7913ce140dc44d0bb985850a2cc30fff883a93a"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2d6c93a2ec72bfc1b9de5fdcc1f77a6f0b7b49b250a3836975d226e7ca7dabf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8e7f35871e1e7cf3126a069d484edb33ae52bbb201849bc2b79b70ed91e164b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "779587ba139102d719d53450ed46e22343a3223b59a790acd18d1c1977cdc426"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1a8b35a44acf64855542ea23b32ed8e1596c23abf557bde707c16a83937fc8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4077968c5e1de983e46a58fac781e7289f97635aed446bac33ea5723752664a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36210a67cfeae942195781e9dcc4d9cfde366b99cd94f24f185137e87fd53ca8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end