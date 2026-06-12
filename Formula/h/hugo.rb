class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.163.1.tar.gz"
  sha256 "5ce13e4f55c2f3a285b5b5cb7a82b6c0e4fb2230531e590f073fe6cf5e4c5c9f"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "195be55af75e96a3ac8442bda64953be9e85e879e3ee3f5f7d0a39304dbcb9f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6df64552d111ee9be655832cee6d901b1c4d5a161b5110a3adb770f2642c2797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de16db9385d55908a028f1b1b84bd58f3fe9dad591379cfd7442af2cf01967b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b78cc34fba77e57ef174b97abe48e22645147509569f5ca3d2b09e45c34a7c63"
    sha256 cellar: :any,                 arm64_linux:   "a0bc76da59aed914e3529093f3def1dea5ea9ef4f448c96dd1fd0abfcfceb1d6"
    sha256 cellar: :any,                 x86_64_linux:  "792928fb64966794a38331f6337c98ed5198cca5deb1c37016ba66d1e7f98b9a"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end