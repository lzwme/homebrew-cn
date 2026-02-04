class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.xyz"
  url "https://ghfast.top/https://github.com/hanebox/ekphos/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "176e455367d6ac361ee2802d7310f4595bc4a94c05781f3a95a74e6d68d8b0ba"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "release"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cda53d70a176b0b8aa4d6aeda133683d0844ddddd304963bee0dbd838680c592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ae1142fcb4b576a8be726a94321c413aeb93ca3765b36c3c8fa0669f8ebab96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76b0576c92b298730b92e7b2f97dc65155f14e82226b2e0b1edfbd28f583a8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b5348f64b80437ea87032ca0269bcc221de9ddd0838671a5ccdc94c98378bf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0547bf734c27f4e6d608a2fed616ab74d192eaa86ab414893e54e82be5ba9a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c772aaf5050cfc5e0a7047a71c6361935b209a4229ceb238bc1c3cf39778d956"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end