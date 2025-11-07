class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.141.4.tar.gz"
  sha256 "04ec601d0bb889878217a0e590452bed388aceb5a84c8b8f02a4bd2a912ace24"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19d4b354c5af7b7f4b5aab7794ac4427bbdfddaeb32caf47a15031603fa358cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19d4b354c5af7b7f4b5aab7794ac4427bbdfddaeb32caf47a15031603fa358cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d4b354c5af7b7f4b5aab7794ac4427bbdfddaeb32caf47a15031603fa358cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd49ea736308ce60dcfc98909af82b5b9192e125bfb0ba626f28783124021bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "278bfddffbc800272b96ac8c7e0114e266656cd407afec757ecfccbe35e013b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4bde4a4d8b2724d0640f1fccc5fe8d08c4f8919b25314f9b1da3c36081f677"
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