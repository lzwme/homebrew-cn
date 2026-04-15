class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://ghfast.top/https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.2.2.tar.gz"
  sha256 "d68bf4b78e5cf1200382b1232b6d5eb6849e9267656618176257dcb9e710e374"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b91612e20736f51c3e5761c2e8c56bf9b647527c3b3d9720deb65da0f02bae77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f194885bc07491a06144319f75ebdde4eabcd7ae99951ac97f66db9ac4c69b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2e897fbb7db7d096ee7ac0bc2dad14cf5f5742801a1e662bbac5065c8732c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc5d950f4589836d8c2d336cd7c5cdb527dba329d582e7c1ca51025aedfc875"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60e99c0b07ddc174758b0c322939f9b243382cad0752537b0f9826b8b88e6b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d99846cd2f15d942c81e7bc0f3eb497cf2362f8ca25b83372710dceef51ac02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end