class Papeer < Formula
  desc "Convert websites into eBooks and Markdown"
  homepage "https://papeer.tech"
  url "https://ghfast.top/https://github.com/lapwat/papeer/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "c40556e73611ec35b63fa3ced92b7479dd1c1107658de7501670a4a5365566ee"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "653dedd20de14700ebd80d6a7b7b5ec51af72c2b8169455b611c18bce00207d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "653dedd20de14700ebd80d6a7b7b5ec51af72c2b8169455b611c18bce00207d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "653dedd20de14700ebd80d6a7b7b5ec51af72c2b8169455b611c18bce00207d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "89cb0e745e63089052d19373ad48ed1b019f59a7032843981ac268b2f0341a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa1a79dd3305a5256cbe0c1d0fac096fd2a16d2a6f0a5441ab81edf6d014aab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1305e70cefe1e3a5b3dba2e8dd82ca7cfa1bc4c76f464441e6d4c254dd67f541"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"papeer", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papeer version")

    output = shell_output("#{bin}/papeer list https://12factor.net/ --selector='section.concrete>article>h2>a'")
    assert_match "8  VIII. Concurrency", output
  end
end