class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.161.4.tar.gz"
  sha256 "16258e8816445828b8eef83ff6fa27958eda3fe986c6708cda67389dd7f06dfd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b19a373cb0464b2a964e5389fd396f9f103c15959b2f3748339c6fe717b562f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19a373cb0464b2a964e5389fd396f9f103c15959b2f3748339c6fe717b562f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b19a373cb0464b2a964e5389fd396f9f103c15959b2f3748339c6fe717b562f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be60105c4ed653f330ad5330c40665248b6df70b616b4b0dad55a4a4c2ae91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60b459a9b6ee5b70d26a8d79904d25dbcf228f777762218e6a2d9c6c14271824"
    sha256 cellar: :any,                 x86_64_linux:  "4c93864e61e774fc4b9e9a9c1500c0f51fad174028fc242d84404f9b18431c22"
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