class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.660.tar.gz"
  sha256 "6dc194b51ca4fa0362dffce2773da734139dd913745e1cab1ade9921c3b4a17f"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a55152e0cccd5eefdcd8d8a622fc7fd15ee4b330e0999f7b3e49c055b0776796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56cbadee19e41293ddbc31f4620248b7020ff5c7c3ea7c657d5655b457798004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9681a9095fde678672843fbff519313c408a12b44db66d722461eeb082708834"
    sha256 cellar: :any_skip_relocation, sonoma:        "17129a6acac2489586469af252bdf94d3d37203562c0ca0ea83b5157c10670f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2c2d4801758bec800d4396d5cf699353214d388783391d59cbef57ce883778f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418e4166e2fbe9e3ccc10f21dcc04a8bd6de62bfcdf26378c6597e9b5aa730ee"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end