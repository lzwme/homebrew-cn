class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://ghproxy.com/https://github.com/kumahq/kuma/archive/refs/tags/2.5.0.tar.gz"
  sha256 "fd66b6b281a94442d546932a6c2516e904c17720f34570c4f3e4756a05a6abfc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc82deaf9c8d0d3840687e89cd2f8b45de00ff8069b9042effd09c6437462276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f40f284f2107b84cab3a5a647f6c0bf5f8489f93e9378ea0eea5d6e634c9fb10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0571a06f4ed4a52508581799ca36557c117a17540bdc2b2034fc08a945f19ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed14b755c99a27280ce1a182eef676880e1c639922ffba54cb768b2447cda6b3"
    sha256 cellar: :any_skip_relocation, ventura:        "debf010a64a98d511eb7855ffb7ae18bb36ae1e2c8db4b01a9cca4918f30fef3"
    sha256 cellar: :any_skip_relocation, monterey:       "b1789060c38fd56f9f95abd0413b13ba616365ced7b5d48261a37bc7073d6c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a005e157c13f18bea6cbc8effc21f0bd4f1863875ff3b2ede020a2d9c1170d4"
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