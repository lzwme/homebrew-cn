class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.47.0.tar.gz"
  sha256 "684c1b696e9504d077a00602f71588806a5e49c45d4cde013e5010a887f18815"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e060136b8904d0908b22200644fc0f15b9291f241b6437242aa4051c336c4c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b7eb9be059b8029db806c95ad5623f78dbb6992abdcb80a56d47a87dbebfbae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7414c51a3d940d2dfed1125dde6ee386ceaf19354799760e7386742b7eeff6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "210a2fa145f17e89309e03ac76e3e869b255fdf82f123f5d4468f7bfe389ccb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88f3123c5a0f21eb4210924a65336895d35c514c0de26e994221dc050e6e437e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97120e2ae154840011029125d417ef9585c94a214ed578766a39a8a4dc785d7f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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