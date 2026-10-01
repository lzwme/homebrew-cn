class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.8.1.tar.gz"
  sha256 "f9940a64fb7990faa9bb1e3137789c19f024aa7a679d88ea76a9aaf3d3c8e9b2"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe6ade7724ea24895294c256ad3001d5f792fd7d34a8efa2434c27111f96415d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4784bbc14719078537ea85b775a5beee63a530fdfeb5eff18c01ee9213148224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bd734eb09b25ebc2c4f830cbbc3725f2ba9d18e7d837d9cb344ec057036f5d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57389e305568292938db57026a5099349dd3be4b3715c5a1fe251379027a4fac"
    sha256 cellar: :any,                 x86_64_linux:      "a993b64f0f2105d1d105d907db0f150fe143903b38d7924ea2d42fc2a31bba18"
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