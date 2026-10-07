class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.13.0.tar.gz"
  sha256 "928fb684618ba269c3aa463a72e8a6dff94f6f46801694a26509438c0db32450"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7724519038f5307e6f3ba31d2d735918aa083fd1318bac5af0fe06fabe2863cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c01e8c2d2f4ea5cc8da8d0061f4eecb47c5cd94cc931bd5fb8c05809260c45c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa149b9d0ae7f44d2d5a0e657c36712042768626022930473473e0990e954527"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff335dbd144ac15621ce6471dd62a167b5dd491b4e5941c546ec18cbfbfd50f5"
    sha256 cellar: :any,                 x86_64_linux:      "3e0c1f56bdbd5a18de9e5059972281c16e7ec59a902b0a2389dd1484b8759cce"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end