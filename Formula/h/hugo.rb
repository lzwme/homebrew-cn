class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.160.0.tar.gz"
  sha256 "38e67688480c71ae3c26fcbd892f405b58422be59b528335a1b088fdebaf900a"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6581936ad379767c7b9277aa38b89fc6621cd0addddc9372ed801e61588f8d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fdb4912cd8caac95cb7d92a2c9b3e1233300bc24d2fade69796bad7286f4937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd14e19351c6b26848a2472b3ba95498483bd26af865e4122fc7fb15d5fa015"
    sha256 cellar: :any_skip_relocation, sonoma:        "6efad3fd434ae7c4f375013d979660541e2b3a969b807f7c70661fc00d4ed7df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b646f9cc0ff05c7cbf05c25f18dac1deadfca531cf3687696fc0f9473e59ada9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90e33b81eccfcc297df8aef7057395b3e07c2139b4186626e739ca2cce83394e"
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