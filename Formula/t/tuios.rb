class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.gaurav.zip/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8c5d7e09a463b144dfb96fe561c8e936889d3befa2f1da1f3e6b9480628fe390"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ede095cc9981202aae251c14faaae6a38aca487b76f50d818eed3e30ef4d5c49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c015ec2f9488d7a6e68a15b9155c3c17a195497232458953e12995f07625c609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d7a8c76634fc88d0d1cce115662469241bbb57f554bba435b4bc90208119556"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19d67eecd27eae3796e8a5e280598a012c8466a6345ee7b108600e7f270193fe"
    sha256 cellar: :any,                 x86_64_linux:      "c8a38b09db4d50ca2bbe37940d5ead18e62c5a4690c6e39a426abf2aef1e9477"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end