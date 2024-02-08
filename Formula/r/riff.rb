class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags2.31.0.tar.gz"
  sha256 "2088ec0a0f7191e13c8fc3687941617630f9feb1813122f933cca5c18cb530f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab66f21e4700a1d88a1ef2291f8b4707fd04a8021dc7259ab3b49ad08728db46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5d66e71b9e73eef83a0d9df5d90a898438e4c6f7803bcf9bb008df7c06a3f64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b2648471c5ca5c27af0acaed123ba526e8de30606463b6f6a62ab1221179ac3"
    sha256 cellar: :any_skip_relocation, sonoma:         "86fc7eb3bced1d2daa531a3d57bc79192673024ed1654dcb4f96f4421c89ed7e"
    sha256 cellar: :any_skip_relocation, ventura:        "04145e954aaf13ec0ed385c9148d60d98d0aa311445a75448d641e80260a062e"
    sha256 cellar: :any_skip_relocation, monterey:       "7f92457031a7db2d491ed039e036a85f906760722ed03eefe04ef4fcc92bc1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e9f13ee1bce6e7793bd92019efb41ccf0f8b8c410617e2f8139be9458a3132"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end