class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.108.3.tar.gz"
  sha256 "bfc67c22f1eaf90e0a6e24b394ff0dba27651aae0330c5b9996911a6ea192a70"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02c5ea3a1c02484843b16c0be34a51c818b575a2c51998f575353decc937cae2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f182d766fc56ad1ad0347b953a05437161b22d5f721c20c91285ae0f984c4d75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c954e40f261dbc17d76586828d86cf7b0bf541c5c8bb98d0e32515d3fea918e"
    sha256 cellar: :any_skip_relocation, sonoma:         "abe80de1d29f6969bfc4b21f3be1a16aa7deff3e4b6f4af301aa6755a1bdfddc"
    sha256 cellar: :any_skip_relocation, ventura:        "ac45cc904e6d9ec486a3ef522ed3d2f4c100145e1011357520168e28dbd8ca42"
    sha256 cellar: :any_skip_relocation, monterey:       "542a5ba71c35048eee63534207b879334e3f26abdcb94c867264b881938db6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eec05895731486bb9f741db26200008190df379d2d7471c36f4062042d21ce3"
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