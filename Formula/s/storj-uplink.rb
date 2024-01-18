class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.94.2.tar.gz"
  sha256 "87a3206dfe45879bc581154ef4c41dd18ddcd533e7457a1fa60f6ffb134c43d4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eb4402f93817fb9ceaaaee418ab6d7c006c05d7dbd83ebe9935a9445bb88d10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8926a1d855486a864d15ef89b37b25f7bc4193a61dd655633bb9f98defccd9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835acb54d4356783e61832dcce48f9fdc5f97c223ec519257ebe83c8c24b3a45"
    sha256 cellar: :any_skip_relocation, sonoma:         "697c3df63a4af85896f091d3eb476c350993885792f58bdefa3ce4245dc6fa24"
    sha256 cellar: :any_skip_relocation, ventura:        "63ba0aa8f68c27f49c78bf815ee808cc44f0a2f38238e9a04b278ebbedffa786"
    sha256 cellar: :any_skip_relocation, monterey:       "13714b8cb3a2f34ffbe2436d45a2ea177c593b0de95bc6a585f8fc745162abb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "478b265b2140b9902531b6e134307bba4262b3097a6d715d0f43c0276d28d894"
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