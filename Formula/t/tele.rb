class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://ghfast.top/https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "5a25407c941d5b3fa1aa1c969ef884191afa0768e7873c82bca4db678c601b8a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1081507f7599f75f9438f4b5a341551063a663bfeb8dd89d3c46828bec38c0f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5513f8ab4d082be5a3f7551fb7f910ecda6acfbb2b20059714639a6155a22d4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8df47fba1b25cd143167b83c91b5243dd23c6c7f21fe40b4169d817279e1fae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e1af9f631705f6d23f5f573547af27c378f5e869cd6ad998cf4096239161dce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cdeb2d78881b519c95fe370a2d4481fdabe78203251a1460d201e5d5342f462"
    sha256 cellar: :any,                 x86_64_linux:  "fe0838a3480e5928a635e5001f79876f3e6c5f95afc382e9f1c8736dd86843cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele -theme-dump tele-dark")
  end
end