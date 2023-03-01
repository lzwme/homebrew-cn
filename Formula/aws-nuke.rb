class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.21.2",
      revision: "e76d21c263477ebd6648fae19f9e539049ad2b51"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd86a7a4313fad0fe7b3166bc97a47bfd4df554d79790dd55e60da9bbf45d295"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd86a7a4313fad0fe7b3166bc97a47bfd4df554d79790dd55e60da9bbf45d295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd86a7a4313fad0fe7b3166bc97a47bfd4df554d79790dd55e60da9bbf45d295"
    sha256 cellar: :any_skip_relocation, ventura:        "d8464526c0d63a628531b94fff979e70fe0d86a51e9ac32b4973305bdca24017"
    sha256 cellar: :any_skip_relocation, monterey:       "d8464526c0d63a628531b94fff979e70fe0d86a51e9ac32b4973305bdca24017"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8464526c0d63a628531b94fff979e70fe0d86a51e9ac32b4973305bdca24017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d19d1926f8122492b19734273fc34b6b07c36f0f4191c04255339c1e98254d62"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/rebuy-de/aws-nuke/v#{version.major}/cmd"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.BuildVersion=#{version}
      -X #{build_xdst}.BuildDate=#{time.strftime("%F")}
      -X #{build_xdst}.BuildHash=#{Utils.git_head}
      -X #{build_xdst}.BuildEnvironment=#{tap.user}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    pkgshare.install "config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke --config #{pkgshare}/config/example.yaml --access-key-id fake --secret-access-key fake 2>&1",
      255,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end