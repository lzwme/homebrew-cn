class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.139.3.tar.gz"
  sha256 "54f526eddd79c763170f4662e26e14629225a9c3726c25c9b97b4beeed5f4b6d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d488a60d415486b4c09b14e2b1ad37b2920480907feb90be22e9ab40b66d622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d488a60d415486b4c09b14e2b1ad37b2920480907feb90be22e9ab40b66d622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d488a60d415486b4c09b14e2b1ad37b2920480907feb90be22e9ab40b66d622"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a8a631e6ce21ebcd14a798346fd5b0571cee01ff501d46e3272122741b69892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c317eb991b442812d6d3c6d21ca0bb6bd32726fc9fe02778405968995be0e6c"
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