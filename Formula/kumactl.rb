class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghproxy.com/https://github.com/kumahq/kuma/archive/2.3.1.tar.gz"
  sha256 "87155618118445dfb4466dc9a63faf556ee86420f5079ba2353e84fd4c46477c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a54649501ab6ed894058113a25309208a8ca28b5c227d28c8c76feb54eff43b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54649501ab6ed894058113a25309208a8ca28b5c227d28c8c76feb54eff43b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a54649501ab6ed894058113a25309208a8ca28b5c227d28c8c76feb54eff43b3"
    sha256 cellar: :any_skip_relocation, ventura:        "6c93d49c90447e11f80e18c036bd9fc77618d8d4b9676460d28ab49b630c0ebb"
    sha256 cellar: :any_skip_relocation, monterey:       "6c93d49c90447e11f80e18c036bd9fc77618d8d4b9676460d28ab49b630c0ebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c93d49c90447e11f80e18c036bd9fc77618d8d4b9676460d28ab49b630c0ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b204c4c14a944ea97f024e0ce4d54bc1422d2306297212b18a6e60cad1e0a76e"
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

    ENV["DESTDIR"] = buildpath
    ENV["FORMAT"] = "man"
    system "go", "run", "tools/docs/generate.go"
    man1.install Dir["kumactl/*.1"]
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end