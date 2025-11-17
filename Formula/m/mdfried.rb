class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "66984768bea0e61d5e907f29606c02b7f322ad9a723aca52e19ee5a54f4bbfc2"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77e0d8c5d9b1cd7e4787fa449edc73f779aa7f560f34434e0e2e969cc10285b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de7c07e4555f99361b6a19549d779fa359870c04dc5f52320ecfdbecfe50293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e5504c335c6125f472e3c35f983ce54fd92b988b81c0d6c70a85f836ae66ed0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2feef37cf2e8a18db148751628431580ae473694d74e1108ee1f2d1436138fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da14f135382e2fb934384e8000769c5a5e072dc7b66b61a1562903c3e4a2fdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8b20c33a91ad495cc8913ed078db8b939220bfdb9d8b9484abc0e9acd20be7e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/mdfried #{testpath}/test.md")
    assert_match "system fonts detected", output
  end
end