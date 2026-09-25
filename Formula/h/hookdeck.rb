class Hookdeck < Formula
  desc "Forward webhook events from Hookdeck to a local server"
  homepage "https://hookdeck.com"
  url "https://ghfast.top/https://github.com/hookdeck/hookdeck-cli/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "82cf9385ceea32154341edca503144fc0fc60e45f1e0fd0389cc853edaf68bd5"
  license "Apache-2.0"
  head "https://github.com/hookdeck/hookdeck-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a6c7fb6de91a8888de59d5e31d4bfeb2d0512ee6b744781d60604ea15d114b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a6c7fb6de91a8888de59d5e31d4bfeb2d0512ee6b744781d60604ea15d114b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a6c7fb6de91a8888de59d5e31d4bfeb2d0512ee6b744781d60604ea15d114b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14df1604ddedd3d8d5de6f00c63142d4719daca9c55867d62f14b63fef84d633"
    sha256 cellar: :any,                 x86_64_linux:      "5a611c666e81dbd9ea59e9dd7f491214d5236edf743570a32621babf19551d10"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/hookdeck/hookdeck-cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hookdeck", "completion",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hookdeck --version")
    assert_match "Provide a project API key", shell_output("#{bin}/hookdeck ci 2>&1", 1)
  end
end