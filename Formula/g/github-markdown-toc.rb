class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://ghproxy.com/https://github.com/ekalinin/github-markdown-toc.go/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "e8252635f85b0de2fd4fdcd1237214eeeeaf5f439f6f2c39182fc00cf3e6554b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b1ffae4ff13510484d9b92da36d5eabd6503dccf4348c46694fb6d2f093256c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f302afa229f6c57145b01001385479109a354c1a875e5121236c6cace7382fad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb7910e927c39861d9adae5fcfd84f3ee57cdef96b213bcc06f9c6cdd8a1192a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6ac4b31d7d7e7fff4ca73e97900a10b935937bc6ecb51f5b6523f06a7963b60"
    sha256 cellar: :any_skip_relocation, ventura:        "a0dbd6294c4654bce5dd2e659083c48d0de29b494b0fbc31a2a6ca0aa2a19a93"
    sha256 cellar: :any_skip_relocation, monterey:       "ccf37b4e222315022b29ef6d3780c5262d0ec16879dce1d499333eb057bd4b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb82828a3be012bcba319acc6bd0b9511eda911c16d21904f5748dc5c1709881"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"gh-md-toc"), "./cmd/gh-md-toc"
  end

  test do
    (testpath/"README.md").write("# Header")
    assert_match version.to_s, shell_output("#{bin}/gh-md-toc --version 2>&1")
    assert_match "* [Header](#header)", shell_output("#{bin}/gh-md-toc ./README.md")
  end
end