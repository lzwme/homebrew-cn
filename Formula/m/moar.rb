class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.24.0.tar.gz"
  sha256 "ba3a62c1197c20f755738a391876b38371e7c116a91812c023fd03c6d538f24f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c04985b9dde7fefc238f249aa2b8d5cd3aa41ab9c89da8838e13adc4b60aabc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c04985b9dde7fefc238f249aa2b8d5cd3aa41ab9c89da8838e13adc4b60aabc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c04985b9dde7fefc238f249aa2b8d5cd3aa41ab9c89da8838e13adc4b60aabc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "abf33d36520bad6dedbf166ab97d8a3d3a9824d882ae34f6240e3197d8cadb3e"
    sha256 cellar: :any_skip_relocation, ventura:        "abf33d36520bad6dedbf166ab97d8a3d3a9824d882ae34f6240e3197d8cadb3e"
    sha256 cellar: :any_skip_relocation, monterey:       "abf33d36520bad6dedbf166ab97d8a3d3a9824d882ae34f6240e3197d8cadb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4afe965a758009ac3ec4c53d7704052d45aa0cac6b07bae01fbdb35e4a198d5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end