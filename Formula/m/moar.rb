class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.25.0.tar.gz"
  sha256 "80099ca09475a2d3bee7207f3a077441574f333172e9615344152129cf8a0696"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e54de69d0d286d1a27dc43dc4e2418f3fe0ff69af03e47406f2db642d74f8f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e54de69d0d286d1a27dc43dc4e2418f3fe0ff69af03e47406f2db642d74f8f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e54de69d0d286d1a27dc43dc4e2418f3fe0ff69af03e47406f2db642d74f8f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fec91bab401c203152f2f232b4981a5c27b2e736045ad5a014a8169fc724d47f"
    sha256 cellar: :any_skip_relocation, ventura:        "fec91bab401c203152f2f232b4981a5c27b2e736045ad5a014a8169fc724d47f"
    sha256 cellar: :any_skip_relocation, monterey:       "fec91bab401c203152f2f232b4981a5c27b2e736045ad5a014a8169fc724d47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8694e0aedac4e7c6c12177030831f8007cea20f3d84d15295340651c2db6d65f"
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