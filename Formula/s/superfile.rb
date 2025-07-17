class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.netlify.app/"
  url "https://ghfast.top/https://github.com/yorukot/superfile/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "372fb9b6f617d64d6dc44bc3becef45c4f804d49374bbbff27c8a0c65fba6955"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27be8c246d8a9cba5cd39ad7eb85a0a24820caf6ddeb0a3bf353a5e584237092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5388911d75051090cbdcadbbbcf801040e7fafa5026e4c52f47d76326c9ea056"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4da4678b3457f804a7d9c2d25b5c3350f40473b2292a75194739efcc9b77120"
    sha256 cellar: :any_skip_relocation, sonoma:        "824b30a7d35d2b6d8cf9409630095518495d2621be502384d2690441a0179d2f"
    sha256 cellar: :any_skip_relocation, ventura:       "9e5461e89c020bd0025eea6dbe467e84dde38de75cc53d877096d24c4267198b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0a53e93481df26466cdf4861cf03e4295846b9f65f45bccfe83a39c9f19ce3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end