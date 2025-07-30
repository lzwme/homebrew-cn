class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://ghfast.top/https://github.com/stackrox/stackrox/archive/refs/tags/4.8.1.tar.gz"
  sha256 "25ed2368244854129d979ae873e87f545dc8de97bd96a61dcc643393829ee9ae"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fc1a97ab310d3d9525c014b73a390d146e5eae276b2c4477e5f981b011ac229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c8094f5d4f067f3975df9c1d1a3e3c2c56ccddd53cf2442993496a3bf7c3666"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dc828ce6d662d0b6d930fc22431871dccdde685b1daf7e0b2020e5eccf92cb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c78a4a363a023b6f5ebf09980bc360104dacd75ddc53adfefd728dcef90b3a44"
    sha256 cellar: :any_skip_relocation, ventura:       "4cf5b8e19828120ce503c04710675228766a50db504d33db7e75148d9656093e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeeea0597e48004fa6769d2a6f5c62cd21ae4d32d4dc28163a59fdaef6b516d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7174576b70d3ef5b8a91182c0daab256f2eb15141ac40416330414e92f7f9647"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end