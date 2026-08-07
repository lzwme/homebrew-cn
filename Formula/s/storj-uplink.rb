class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.161.6.tar.gz"
  sha256 "02f2f96a0d701e94df842a0e46b5d228a7d5039f5e11bf8f9c7a1bfb556c3a00"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aa2b374fb63291ffcae1e630fc9dfa04d1e48a75b81a3c7771efb8dacfc1245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aa2b374fb63291ffcae1e630fc9dfa04d1e48a75b81a3c7771efb8dacfc1245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa2b374fb63291ffcae1e630fc9dfa04d1e48a75b81a3c7771efb8dacfc1245"
    sha256 cellar: :any_skip_relocation, sonoma:        "a61072fe9d84e62e3d0064838f386bf91365a6659fd55efd60ec8cd9ef8549f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7afeb104777cca01edcd68b3160f249cff3cacccbe925c7bf46ebcb5fa146b22"
    sha256 cellar: :any,                 x86_64_linux:  "6a04cfa08b0f5d012e7ad098e76d7dc937d9bbbedce83a90717ce0c46637ff84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
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