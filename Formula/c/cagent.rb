class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://ghfast.top/https://github.com/docker/cagent/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "61aa5ae5beae7994e0969d87a05f42d161c1f006aa9eaaf5997462c18d2fe370"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "419f98950c282edd5b0663bffdc7557a49b122534e8407cefbc3ec27e0fb0989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "419f98950c282edd5b0663bffdc7557a49b122534e8407cefbc3ec27e0fb0989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419f98950c282edd5b0663bffdc7557a49b122534e8407cefbc3ec27e0fb0989"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aecf6157813ac87f54b0403ea2c9d5bc6e89d69af03e78b938fff988b46a293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e79fc7d8f90e96e5f625e5b2a488dda05cbf9b8290238ae15ccae0d6bf51dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1c8647bd10868ecd44719678f0e428e0881de3f21f226e3d31cb528a3d0db1"
  end

  depends_on "go" => :build

  def install
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