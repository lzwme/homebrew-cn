class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.131.4.tar.gz"
  sha256 "56f5f20473d703959f2647ad3171e79ac510702e86b38aef80e37378f2e0c2ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450eca77df0ec49bb716573751ce9e293f456b781a79ecf0bb4dbe806c45e835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "450eca77df0ec49bb716573751ce9e293f456b781a79ecf0bb4dbe806c45e835"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "450eca77df0ec49bb716573751ce9e293f456b781a79ecf0bb4dbe806c45e835"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d469832498874ebe9cf066c486e5406d7ccbdc1becddf6831c6e61f48e807c"
    sha256 cellar: :any_skip_relocation, ventura:       "c8d469832498874ebe9cf066c486e5406d7ccbdc1becddf6831c6e61f48e807c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe921a69912559af8478bfd16a2b97b6f1d158fa0a446ad154604cd6885dd756"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end