class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.22.3.tar.gz"
  sha256 "8134505c476b6265adcd34d3423cf60c69716c46c63a49e5600e77105c2ffb97"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95e9954f7d86e2a25290210658f5e12209380301a0885bfebbd26ebe57efde66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95e9954f7d86e2a25290210658f5e12209380301a0885bfebbd26ebe57efde66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e9954f7d86e2a25290210658f5e12209380301a0885bfebbd26ebe57efde66"
    sha256 cellar: :any_skip_relocation, sonoma:         "88a98c5e52cbf71ef133ad12242b4d7ef36722773013aef503eab680af6ae984"
    sha256 cellar: :any_skip_relocation, ventura:        "88a98c5e52cbf71ef133ad12242b4d7ef36722773013aef503eab680af6ae984"
    sha256 cellar: :any_skip_relocation, monterey:       "88a98c5e52cbf71ef133ad12242b4d7ef36722773013aef503eab680af6ae984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a08b5f52826ee34c37dba05226cbf7ae4ddcda8194c75ce925f5f7c8053f0b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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