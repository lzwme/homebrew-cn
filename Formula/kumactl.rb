class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghproxy.com/https://github.com/kumahq/kuma/archive/2.3.0.tar.gz"
  sha256 "893bd6d6e5d70101a8e42e72fdba448e02b6e773a21a32ccdc9a13fdf0ba9e58"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f4c0d7a1099831abd5de52343b1d993fa8043b223b0425f86517f7e59f41e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f4c0d7a1099831abd5de52343b1d993fa8043b223b0425f86517f7e59f41e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9f4c0d7a1099831abd5de52343b1d993fa8043b223b0425f86517f7e59f41e7"
    sha256 cellar: :any_skip_relocation, ventura:        "10e0e973764d24652aeb7fc7b628ea54f3c80e07fffb8d28428c437ec609a403"
    sha256 cellar: :any_skip_relocation, monterey:       "10e0e973764d24652aeb7fc7b628ea54f3c80e07fffb8d28428c437ec609a403"
    sha256 cellar: :any_skip_relocation, big_sur:        "10e0e973764d24652aeb7fc7b628ea54f3c80e07fffb8d28428c437ec609a403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9923316672b35e18e6eea5771f61160c2c7409a933fdecb91d4987aaae7c2a3b"
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