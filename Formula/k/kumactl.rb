class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghproxy.com/https://github.com/kumahq/kuma/archive/refs/tags/2.4.4.tar.gz"
  sha256 "d62a5a615d0c6f642eb96f1f59e8b43a5bba628e1e2c94822024e886a7cd3c8f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "482e18b960890c0cd30ecadc30256bd6816c92b5ffb7a46147309af426f618ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6223a34d7a7b1b22d1044d183a730332c3c53e46a99c8aa0bf246df276128ed5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e832ba7349a705060f37c16f2a975e922014d70fa5f0b9f67491cb0ad8164878"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f0fe5643e331824d42df47eb727b34c6bc61c0253c51ccfb5d739cb413e6c95"
    sha256 cellar: :any_skip_relocation, ventura:        "e914656d60906fce8aad31f4d1771b6c20943bb1e81c9a4ed7358dd527883df4"
    sha256 cellar: :any_skip_relocation, monterey:       "b44ac7917c223a5ba92f7d9c171dbad8c45edcec14f64b87038ac0ecc2fb3320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ef0e714f02c42c817713ef6d736adc29437782dd9ef3b2d5c29e600cc6a60f"
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