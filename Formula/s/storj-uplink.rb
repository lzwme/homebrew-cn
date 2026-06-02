class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.155.4.tar.gz"
  sha256 "0ef073c2dc92d316c4308ede95eba3469c6b6f730035694c052b1363ea0574f3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6ff4765307a29e940bc27e6378d344e89b9c086b637bd9173598fc3a1a4734"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c6ff4765307a29e940bc27e6378d344e89b9c086b637bd9173598fc3a1a4734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c6ff4765307a29e940bc27e6378d344e89b9c086b637bd9173598fc3a1a4734"
    sha256 cellar: :any_skip_relocation, sonoma:        "25484586376e1b36563decb6cbdb812fb3349b61c6022061be0b5398d00fed8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a73578cad9a4702bf6074b33d50167778f12f104053a0c1bcba93be943125601"
    sha256 cellar: :any,                 x86_64_linux:  "fa52c74cb6caf921bfc402c23c871a5218618f54a28bdfe056495738fc502a1a"
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