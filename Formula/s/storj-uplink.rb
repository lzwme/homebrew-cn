class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.117.5.tar.gz"
  sha256 "def2e67dd05c172a964e6e8d45269b677c437a89e5bd7f40068722ab092e6bc6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f4dbefcc324739714a8b787daedb39484bd86804f569f98f3dba6bda1df846f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4dbefcc324739714a8b787daedb39484bd86804f569f98f3dba6bda1df846f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f4dbefcc324739714a8b787daedb39484bd86804f569f98f3dba6bda1df846f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a017fcd88c0602ba5c3f1444d755e90bfe6a05dffe8950f638cdc555f78e499"
    sha256 cellar: :any_skip_relocation, ventura:       "1a017fcd88c0602ba5c3f1444d755e90bfe6a05dffe8950f638cdc555f78e499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e734a9484ea26e82ca8b5e00632b00940aba60f5bb452ea3cb0995603054e5ad"
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