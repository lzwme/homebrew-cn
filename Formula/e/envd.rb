class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghfast.top/https://github.com/tensorchord/envd/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "39755a0a1c4affa4de07b608e49728e9dec5aa69217d1ec75f83983219e30fd4"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aff5a32b2199fbd8d6f754310cb5dfa053334018274e9933407be72dd7f92f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7480cae73fffdc70e78811bca10f228603f038285ea400519f2b6fc806c35fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9986acefcce47fd3c0f6096e4b1a2086a6f23a28427caa38c4189f11c62e7eee"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a6746bbdfbf9c885f32713f643cf36924155ec67c4e33fa90603f92b9d09a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a808572f4df945685b4af45ee7f6a80097e0f15cca3f84c8d22836541f054dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17cb007c8a6b7015ac2df50fb15efc094279fa2d62faa0e2fedf6a7f737dee5a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = /failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon/
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end