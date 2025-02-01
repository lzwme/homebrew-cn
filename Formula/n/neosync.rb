class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.14.tar.gz"
  sha256 "66fa77b99c6492bf3692c48d258a1109482fb61ea1c8a6ae6036292e526704f6"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "136ce05b0ccaa9d01e0e6f92210119d5fd14f584b23df7498d77083c9676b14c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "136ce05b0ccaa9d01e0e6f92210119d5fd14f584b23df7498d77083c9676b14c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "136ce05b0ccaa9d01e0e6f92210119d5fd14f584b23df7498d77083c9676b14c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb9a045f3f92413fce6d6eda8422660a0c094ac1f96585dec099917792024f39"
    sha256 cellar: :any_skip_relocation, ventura:       "eb9a045f3f92413fce6d6eda8422660a0c094ac1f96585dec099917792024f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e03f1ed60fb9f1ba73582960635b375826b10b13bc704d4b95a5fcc0e889ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end