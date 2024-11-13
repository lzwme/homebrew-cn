class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.117.4.tar.gz"
  sha256 "26216f4b36afdd94b0042a5385b23b58a6d10963f0709bf478f4a7ee80f58fa5"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy ifwhen
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d339f84a86b4eae87d0a4b511b06db5f3e9d037768d05b3f5d41c5bf2f532f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9d339f84a86b4eae87d0a4b511b06db5f3e9d037768d05b3f5d41c5bf2f532f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9d339f84a86b4eae87d0a4b511b06db5f3e9d037768d05b3f5d41c5bf2f532f"
    sha256 cellar: :any_skip_relocation, sonoma:        "20530956a12d8506e93ccfda99281e98cf53ad5f06822ddf3461b5593e0eb481"
    sha256 cellar: :any_skip_relocation, ventura:       "20530956a12d8506e93ccfda99281e98cf53ad5f06822ddf3461b5593e0eb481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e423bee9f2585789055e167b1dcf166b2fe1e18abdb3fdaed2bd214c3625eccc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end