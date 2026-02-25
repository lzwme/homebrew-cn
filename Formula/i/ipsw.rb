class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://ghfast.top/https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.657.tar.gz"
  sha256 "3a873d6210fdf2f4770104120b98ffbf2d31d2da21b62b054e31c8d4d5fd2ed0"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b5ff96154fc067d3caf3e8e24af33f1e6c3ebfe0ae7917d503d83e2b93bdd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8823cb6e084de2d840484a3655fe52f8f6f7533eee6d4de097f068437ac037c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b99935ced0d32163663f175b33b179dc758b6b379690d2690b65b19e54e321a"
    sha256 cellar: :any_skip_relocation, sonoma:        "020e0f91a777ffa74663fd93844b7a79ad2f90c5d75601bec89c6aa48cb609fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "875707d6ab88d557ac802b4ac5e4bd3b28ccd09186da6c9235b283d674b3a625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1f6c579a5d2a1d7f069782eb0c9e95504acc2cfb22ed2ac1b8e0f923c614d16"
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