class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.113.2.tar.gz"
  sha256 "128106b22917c762581b2a1191c68ca10fd7d31bc77e7d4253d40f7f79a86e85"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af864f95ce656332bbd6baa1426a871115e255ac613159fdb61eadba02896fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af864f95ce656332bbd6baa1426a871115e255ac613159fdb61eadba02896fd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af864f95ce656332bbd6baa1426a871115e255ac613159fdb61eadba02896fd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb6cbf51b2e80de2739c4d709038175b3009c26ec5c8fbaae7f72893243d1ff"
    sha256 cellar: :any_skip_relocation, ventura:       "4cb6cbf51b2e80de2739c4d709038175b3009c26ec5c8fbaae7f72893243d1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d9fb10617b654296df6f54a05a12da8b5d446ca632d73662e77227aabb96cb"
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