class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.23.5.tar.gz"
  sha256 "f3c1c88545afde91d685943db20be1ae003b15c855faed9db61377f2dc768f4f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd33b38565a4c6c0932ecb1b7462054c942e75619d5c214545037ee0779a0095"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd33b38565a4c6c0932ecb1b7462054c942e75619d5c214545037ee0779a0095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd33b38565a4c6c0932ecb1b7462054c942e75619d5c214545037ee0779a0095"
    sha256 cellar: :any_skip_relocation, sonoma:         "239012a99790968fbb625fac265908824899b1c75fb6f04085033540802165d3"
    sha256 cellar: :any_skip_relocation, ventura:        "239012a99790968fbb625fac265908824899b1c75fb6f04085033540802165d3"
    sha256 cellar: :any_skip_relocation, monterey:       "239012a99790968fbb625fac265908824899b1c75fb6f04085033540802165d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f6b9ace03856d834dba656559769754c614704be80d8b1731eee92ee16c4a2"
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