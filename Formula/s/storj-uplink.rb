class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.104.5.tar.gz"
  sha256 "38d4e1d498a7f9dfae3379fb737edc1138f89d61ba07cc7ade245c023fe93bd9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e08b91ac739d696171ec7bcd4d0ef075171b8e258ab4b3de02df6d0d5812df7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdeec644512fac34f00d6a4ddd681ce72d7bc9961b3fc5403930257af295a8a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70659c971fc22f735a51da68d9e46fdbc34f637e02ac5603adb501da386f7c29"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0a2d3beb7b7ea4c719098b2ea9489caffe2b4d0b2ad87c4b2e16a4fa4c0daeb"
    sha256 cellar: :any_skip_relocation, ventura:        "72d3bf06ee444804d9fce657743f9c07ecf6ff68a9ca60d03fbb004849dc01a3"
    sha256 cellar: :any_skip_relocation, monterey:       "659e23dfc7bfb144210e8507baeee420412fe4a07ae7bffe5213cbc576917ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e335668e101fa3b01e0027b881f824f12f8f4b7d4c84e9bcfdbc8d22a06465"
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