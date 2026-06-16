class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.163.2.tar.gz"
  sha256 "69d6e84705d5453ce69d6827901f1320878ef7238f95370b31aff7c5aeb1f0db"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbfb9c971920982ddf0b4e396b75800ff216f7f4b33f2622a249a70af5c1b4f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c9e8ac888b6d4a5214604bf4e57f11d99bbcc52ce42e99035e869dc1d9d4dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4937e86f381200df3f665b1166b64243d6c1fa0687597f76d9afe78c66fae6cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5476541cf7cb4496f5a9047dbaf1a148fb1acab4194690da1f57db4fd59ad39"
    sha256 cellar: :any,                 arm64_linux:   "2b322fffe93ab68b0455f47b4728b32a7e1209a4adea0ea1f1123f1c5891d7e1"
    sha256 cellar: :any,                 x86_64_linux:  "c31016e1c2765abdf61da594ec94baf3b4bd6711d744801ecb1ae14da10b3200"
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