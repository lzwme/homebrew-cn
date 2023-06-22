class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghproxy.com/https://github.com/kumahq/kuma/archive/2.2.2.tar.gz"
  sha256 "5fccd9a046f285a7e8c2de92f4f50c7a821e26aa745496b06603c7b2c46b6181"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9f08fb4eb74c128bbf6f5c45bcb8d9a743557fa2a84f79db2b1bdbd8aacd601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f08fb4eb74c128bbf6f5c45bcb8d9a743557fa2a84f79db2b1bdbd8aacd601"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9f08fb4eb74c128bbf6f5c45bcb8d9a743557fa2a84f79db2b1bdbd8aacd601"
    sha256 cellar: :any_skip_relocation, ventura:        "ca6fffdd8289eb66b195cb5cf650f390b4ec6e9bf863e590edfa3724600f809c"
    sha256 cellar: :any_skip_relocation, monterey:       "ca6fffdd8289eb66b195cb5cf650f390b4ec6e9bf863e590edfa3724600f809c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca6fffdd8289eb66b195cb5cf650f390b4ec6e9bf863e590edfa3724600f809c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12ed1c7608f12da5bd0117e294089cd94ae57327bc73311e10a2a93410b3194"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end