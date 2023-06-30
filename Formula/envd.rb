class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.30.tar.gz"
  sha256 "d57417d8a19b373e49a2ce53fdebb44d13ed5240446cc9a2dad06373f4e585f4"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec8394951e3a22a2b2a65372219f3ad34b31b15e215b6814138e752fd22560e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8394951e3a22a2b2a65372219f3ad34b31b15e215b6814138e752fd22560e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec8394951e3a22a2b2a65372219f3ad34b31b15e215b6814138e752fd22560e9"
    sha256 cellar: :any_skip_relocation, ventura:        "a572de1c9df7e459ac0588a8868d0b34a4e2e864776fe21d9be52a9345cda531"
    sha256 cellar: :any_skip_relocation, monterey:       "a572de1c9df7e459ac0588a8868d0b34a4e2e864776fe21d9be52a9345cda531"
    sha256 cellar: :any_skip_relocation, big_sur:        "a572de1c9df7e459ac0588a8868d0b34a4e2e864776fe21d9be52a9345cda531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c6309d37b0a9f7c72101086c0d294b491bbfa8cc1de44df6b7e25501e5d0eb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end