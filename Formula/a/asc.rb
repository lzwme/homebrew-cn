class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.8.2.tar.gz"
  sha256 "5d8235494a26c418060dc319611b3d95af0fca56e5493849956d2676ba08fe91"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b4be5a3dd4ecb63eae0c7c2c3161e6da1280b330afc6a19db28abb9ddffe289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "546bbfa28d14b8d681bb3ee1a343d5f3b939e40613706cde42746389f9fd50ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "417919007b777fe2b9997b1de2a227e22836c3149bcea7cc2080193f8e92e159"
    sha256 cellar: :any_skip_relocation, sonoma:        "295660ff6d226b68c03b19771605f7d26bd0149710ddfc1590cad13d4d20f6fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c8321abb637bd9b36a4e6bd16055cd84b77e4b3957717ce16e00f26e987c282"
    sha256 cellar: :any,                 x86_64_linux:  "40d685570e9d7a7707176ed3707b457ce6cf751e557763a4ed73df0cea6d2ca1"
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