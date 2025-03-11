class Envd < Formula
  desc "Reproducible development environment for AIML"
  homepage "https:envd.tensorchord.ai"
  url "https:github.comtensorchordenvdarchiverefstagsv1.1.0.tar.gz"
  sha256 "c48884c17ac8608913efe1aaf736a6212ce109c2ba886b2a1dedda8abdd5ffab"
  license "Apache-2.0"
  head "https:github.comtensorchordenvd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31f6d649322569b07b35be03b05e1d629766e084ee08a2832701ce6e1fab5d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff29a4be2b945f1b22550c6a368dbfba2cd159c052e4a964908c3bc23dad3ccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f99ce4ccb468cb7d332dd9ad01edefba46cba668873ae0fac55b81869da265ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "11f0efed0ec18ba11e917da7a193a47bdddd3a646fcfc5d12b8b90f5c23ce165"
    sha256 cellar: :any_skip_relocation, ventura:       "17d0d3b0b5b06b8cdc6074eff44def9ad97bd421ea364175cdd949a545f441e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4601064127e8537e577f31d7600972b4b2646bfc5f541d6e71968968f8e3e3d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comtensorchordenvdpkgversion.buildDate=#{time.iso8601}
      -X github.comtensorchordenvdpkgversion.version=#{version}
      -X github.comtensorchordenvdpkgversion.gitTag=v#{version}
      -X github.comtensorchordenvdpkgversion.gitCommit=#{tap.user}
      -X github.comtensorchordenvdpkgversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdenvd"
    generate_completions_from_executable(bin"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}envd version --short")

    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"
    expected = failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon
    assert_match expected, shell_output("#{bin}envd env list 2>&1", 1)
  end
end