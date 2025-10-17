class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.151.2.tar.gz"
  sha256 "111f545201b2bedb38313e9d69501cf92f440ab60bf2e903647d3e02af9490a3"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c5dc56228125eb4a776834c9162a72e5965ca7156d05740e7e8194bfc542e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50fe1912365c61a0efddc04006d24e5f106d94949d82eb05a417eb2cdb9c550b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7d7615be4c59db2f7c2bc46264d4bdd9ab48ec8ab57b506560e285a2bdda80"
    sha256 cellar: :any_skip_relocation, sonoma:        "445e63a43139c1036a9476422042cc795e3735d10847b5d35b1c14e28406c7e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ba393ccb7f11744b58948ca0816cd35a20c6a17aab6dfb5bfe93f5c647e445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d13cfba225df24fcf636e52d7a9fdb95936016c8edd771aa7afbdaad321e16"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end