class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.135.3.tar.gz"
  sha256 "ea3ae5dd3f24d4840477590d5d0d5f5f0aa8ce9d6d9fc52899ee67ef279f44db"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f364d06c79f749f76b1eaee8c4d8aaa206ab255e1a9c15c6cf58cf5a96cedad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f364d06c79f749f76b1eaee8c4d8aaa206ab255e1a9c15c6cf58cf5a96cedad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f364d06c79f749f76b1eaee8c4d8aaa206ab255e1a9c15c6cf58cf5a96cedad"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f80cfa82a54b526da4230f921bd94dbec6edaa2bf92792d9c5771e477a9f620"
    sha256 cellar: :any_skip_relocation, ventura:       "7f80cfa82a54b526da4230f921bd94dbec6edaa2bf92792d9c5771e477a9f620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf54d1b2bbb7a277ab4617b71620a9ef91ca7170a635aa25f5138a1c1d327f9"
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