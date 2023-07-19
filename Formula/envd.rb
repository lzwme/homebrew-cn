class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.36.tar.gz"
  sha256 "41529e0697912b852bb29409c0c31a4115bde3a4c0182a6ae1bf10321c5953e7"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e3101a07a0be96eec0b4729e997e72b7a03be3038dffd0b38697c88da0c2f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5826afa99954912df715d6c209a39fba88e0ab4ae9a2691964c63ac1fccd879c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f055c9974faa4cd3d255004a0740ad5b5e64550f7cae69cce0114b0620f941f"
    sha256 cellar: :any_skip_relocation, ventura:        "76361a689fbcf9cce4ee1bb75c7777a0a84eef72cd8061b54273198e0e01c29d"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf81a0cad4b5ec3320a1dd64911b7fc5b302744783b7bf80b41401e7983f99c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc7c8ba5967430d6ae76b77f7206d2ffafe3fe7464f9c7b6de8ef88f934a7a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6821aeb93fff638a74942396007626500d4964d632824ac7af5eaaec820b5f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end