class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://ghfast.top/https://github.com/yarlson/lnk/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "18d9b61e558004073ba7f680fd575fd498dd0ef0c97c0487c93c7d5152856ca9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49eafd220f623f245a17df428ae06faeb2cb1e38f20cd24fe455435865d2a4c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49eafd220f623f245a17df428ae06faeb2cb1e38f20cd24fe455435865d2a4c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49eafd220f623f245a17df428ae06faeb2cb1e38f20cd24fe455435865d2a4c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7bc61412996f060c7484e4fbe1018f59cfe51f977429e928ba8ccdede555ca"
    sha256 cellar: :any_skip_relocation, ventura:       "5b7bc61412996f060c7484e4fbe1018f59cfe51f977429e928ba8ccdede555ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04dcd6d3af3210caf7e15324f54d67e571f71972fa2b84aa4d89eac3a630473"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end