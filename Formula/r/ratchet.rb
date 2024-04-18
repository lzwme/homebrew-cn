class Ratchet < Formula
  desc "Tool for securing CICD workflows with version pinning"
  homepage "https:github.comsethvargoratchet"
  url "https:github.comsethvargoratchetarchiverefstagsv0.9.1.tar.gz"
  sha256 "4c0cc09c952c23d788ef256777ed6ab54ac9e68c390bbfb5f11492aed627814e"
  license "Apache-2.0"
  head "https:github.comsethvargoratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccf176bd4be1f20cad9b9aa731a939903f839bff7fe6578e4b249755c4ad1ba8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e6adc2cd2d37799c345af18dae2b6660a5d44693292e06dd7afe7b96f1fc57c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffe398c6fda02c7a6cd5ca3f2aa87b7b30db3aa31ce2b01ec43a68eb76346bbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d6d90a867a534c33f2836c0dc362cac52aee6b9be5d82eaaa87ea882cea4ac1"
    sha256 cellar: :any_skip_relocation, ventura:        "7425d89b9ddab060c6dded9dcbdeabbf7c9bfe8a0cdd7c240df9f70f803e6fcd"
    sha256 cellar: :any_skip_relocation, monterey:       "6ecfa791b15861b124505f392f34e6e9e25f85eff0b26f7ce5f484079d7ca257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7934b39347034fc5468c5da5a013bce610bc9c5c378f629d3af1ecad140ff67a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.comsethvargoratchetinternalversion.version=#{version}
      -X=github.comsethvargoratchetinternalversion.commit=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare"testdata", testpath
    output = shell_output(bin"ratchet check testdatagithub.yml 2>&1", 1)
    assert_match "found 4 unpinned refs", output

    output = shell_output(bin"ratchet -v 2>&1")
    assert_match "ratchet #{version} (homebrew", output
  end
end