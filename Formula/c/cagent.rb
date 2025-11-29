class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "04c8b5b250c66ad6ea653de4d6f13f71aab982058920740d57ad709ad21ec292"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2f2584ff9b447b917a5f6b9902a06f6c2254d030ceb8a8c2b32f6fb92fb373d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606f698a92c9c62a502997d275a429256bded88201971a6c083428f79e76d511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2d8221c72901b0560a7897dd15acd4ba35a5109287b3a725e6e2c69bec556c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "479bebb4b26646e2acab3813dc4d4f81d4a2a532fbc3e5a1db0365f16a88d937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "433b8347597b64f615f75297c75fd0c9b9c40c264519095ea5ec18075546a2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "210440eaf055f98de1b7e0db7fd47ab35f4f633f6248aef1c213993df635c547"
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