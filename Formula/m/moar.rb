class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.22.2.tar.gz"
  sha256 "df0d75529da1ae6ffaccadf903c93da23486963c6c9d8a5ed3bcc24e184b5f7f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9396248a5fe35e6afb89456e572682ec5815aa8f8e20b541753ad2cea1817399"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9396248a5fe35e6afb89456e572682ec5815aa8f8e20b541753ad2cea1817399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9396248a5fe35e6afb89456e572682ec5815aa8f8e20b541753ad2cea1817399"
    sha256 cellar: :any_skip_relocation, sonoma:         "8991574b429a9c16eef5763109ff43aaa33ecc1139e7dff732f54fdfacb16ea8"
    sha256 cellar: :any_skip_relocation, ventura:        "8991574b429a9c16eef5763109ff43aaa33ecc1139e7dff732f54fdfacb16ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "8991574b429a9c16eef5763109ff43aaa33ecc1139e7dff732f54fdfacb16ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be5751c7f1eda3e12e43a7a09fa42746273a8a164af8c696a1d1b394e6de4a8a"
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