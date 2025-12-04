class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.143.2.tar.gz"
  sha256 "d93e29fb10785cf6f96429b272c1c475511d560d4665290e3acbc115b0ecbc39"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "810b9565de5b5a8bd48677b2fe887c8edfe76eb12ee06806e25dac613db6f6b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "810b9565de5b5a8bd48677b2fe887c8edfe76eb12ee06806e25dac613db6f6b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "810b9565de5b5a8bd48677b2fe887c8edfe76eb12ee06806e25dac613db6f6b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab4412432a71e42d9c5c12fc201da35ec7ceac546ceeeebfa26f218ab377e97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aedbdbea8ae8c949241472dba8ea449c2ab2cdfb6621becf0800edf35ef98165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3062abc5e4f913c2618e42a0a412f52dbb41a5670494ffa9e93c34391b6c3fd5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end