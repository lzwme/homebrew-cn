class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.155.2.tar.gz"
  sha256 "69803efca258dce295d8965800657b12c95d5e58d016be7131e39ae36bb97797"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c9f2789db91529d96e0ed75ced5e34585d8d05ff804da4391f084caf9120a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "400cb048a964b0e2aa182fe4f963242cb553c59425be45b27f7b6ecc5fdfcec2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe138b619f638aae6359720672976edf7eb3bc4bd8c81fae0d60f152868a0cd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dba4302b63206d5c86b3f2ab9e803f514798d1db20d91d077cea86d78f84cc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d313b9740b09d889e8b78adbece3cc5c066d084b1d05e1560c55387106ca8405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a412aa2754ab4886c0649d64de4158e7e1d93c4495caaa0da4e944aeadae3797"
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