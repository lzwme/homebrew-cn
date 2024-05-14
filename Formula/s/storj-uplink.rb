class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.104.2.tar.gz"
  sha256 "acad9d0659e2956b145408c0d72c1459cffc1f40cd99c1bcf8f9284addab7951"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c168685283c32bc740ea7794d71e94a13872f78ed9c3cc50638f81b445b25205"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bea577312ff67c14c28311ac4edb8e358b0254cc53e7fb92b526268984a41ec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e358533e9f49215c74ac6c33849b45a2b422f42338aea5f1a2b9469232e757b"
    sha256 cellar: :any_skip_relocation, sonoma:         "df05fca03ae64373d257b92dba42b5345d645ce38d07a9731068b4cbc190212c"
    sha256 cellar: :any_skip_relocation, ventura:        "88308dde475f72175793146ba2e1222d57ac30756b64da5d3e4274fba03ef359"
    sha256 cellar: :any_skip_relocation, monterey:       "38996aa5d6ca79a969321be951abf9fd3a92089e13aafaca7ab3c725afaf421e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f207e87e943e639a5217ba7a33cf1ce809b72364759b1b6dfe89e8ed02b2b50a"
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