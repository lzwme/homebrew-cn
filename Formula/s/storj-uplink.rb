class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.116.5.tar.gz"
  sha256 "58c94ffc34ad92c9b1178295983d9eb240486946bedcd9132dc85cf1dfcf3e9b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dda1a8adbd10a6dbd58aec6eb7238f76192b91d56a05f835762d135b7d4d560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dda1a8adbd10a6dbd58aec6eb7238f76192b91d56a05f835762d135b7d4d560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dda1a8adbd10a6dbd58aec6eb7238f76192b91d56a05f835762d135b7d4d560"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a90a201e33761c1e717cc03bdd5ee97d1910513495f3a73c27b2c22b4f6048d"
    sha256 cellar: :any_skip_relocation, ventura:       "4a90a201e33761c1e717cc03bdd5ee97d1910513495f3a73c27b2c22b4f6048d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2331be1e2318a8480510840eb3b67249247a2b5801ca79483750558826f3ddf7"
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