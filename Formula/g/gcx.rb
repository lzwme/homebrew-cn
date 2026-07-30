class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://ghfast.top/https://github.com/grafana/gcx/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e4095c1462a4f69eeb5ed356a13efe5b25b5041699d9ce7b06e38ba4b1c5627f"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9620921bf64e921e1da9e4d3c030b214e6e8b510c98004bc31aa72844e320c14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ff74d6c0757cbd260b4191b60f7335d1daf90371abe125cb44f74808f44f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7288312459b83befa23a4bec95480309f713535ca3efb7d86a07635f845cf3aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5050f88958cbdbc1cff9f1b11031592d7fe498260cf5c39f2e27e9c3fe09490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a7a3c3196c4bc5df96466a72e341a1b55bd8d4d65b3821078554372d3279fe7"
    sha256 cellar: :any,                 x86_64_linux:  "580c78286379d976d228229fcb34c668d4f3414d365b5d61623e48eb85496cca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end