class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.24.4.tar.gz"
  sha256 "817f42e8760b6e0663b4fee55c02a3f9cd8730e2d39542a73658c9ee59dc8d33"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9d00aef2834305593797d750a2ee28ab8af124eb46e7528db53aff210ac70d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9d00aef2834305593797d750a2ee28ab8af124eb46e7528db53aff210ac70d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9d00aef2834305593797d750a2ee28ab8af124eb46e7528db53aff210ac70d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc5e3ba9eb4a1ab1e3a209cac69e36de62c965e43614992beef59216d5e583ae"
    sha256 cellar: :any_skip_relocation, ventura:        "dc5e3ba9eb4a1ab1e3a209cac69e36de62c965e43614992beef59216d5e583ae"
    sha256 cellar: :any_skip_relocation, monterey:       "dc5e3ba9eb4a1ab1e3a209cac69e36de62c965e43614992beef59216d5e583ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6a4a0741f772164d74be3a10df313bedc334f8cabdc1256004b315f449a805"
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