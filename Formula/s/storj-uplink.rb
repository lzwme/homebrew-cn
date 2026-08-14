class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.161.9.tar.gz"
  sha256 "7667a4a803294247435d5236d203d5efead20da79939068af888e9aaa0e226e9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8880f0cb60ca6e2756094f49f445450a063d0d8ae950b35af29d41d96d29e938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8880f0cb60ca6e2756094f49f445450a063d0d8ae950b35af29d41d96d29e938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8880f0cb60ca6e2756094f49f445450a063d0d8ae950b35af29d41d96d29e938"
    sha256 cellar: :any_skip_relocation, sonoma:        "66eadce157aeead620d943e9b781cbe8de8985833e84b9e3c3900459559e46bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40555106ea556da255f499e027be8945b8007ad6704843c7df543e67db35600f"
    sha256 cellar: :any,                 x86_64_linux:  "7542d562a44072361b40aaa7269e7191b96b2f9ebafd52cc0b59ebb3d5f20bca"
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