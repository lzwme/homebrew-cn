class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.23.2.tar.gz"
  sha256 "f81b1bdd1d88d5148d39fe6a0e50cdd10418d9ed2ce1ccef68de90bfa088321b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0c9fad608dc589237782b9eca893a5b5b141f907cc2caf91fa437de40752793"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0c9fad608dc589237782b9eca893a5b5b141f907cc2caf91fa437de40752793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0c9fad608dc589237782b9eca893a5b5b141f907cc2caf91fa437de40752793"
    sha256 cellar: :any_skip_relocation, sonoma:         "1406c79024c4050386845be7b19f535de35a28f9f78e0d98128b0dd48b7135cc"
    sha256 cellar: :any_skip_relocation, ventura:        "1406c79024c4050386845be7b19f535de35a28f9f78e0d98128b0dd48b7135cc"
    sha256 cellar: :any_skip_relocation, monterey:       "1406c79024c4050386845be7b19f535de35a28f9f78e0d98128b0dd48b7135cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35fc5475d2f67a8a44a451e816f60145f21497af9fbc1608d06144b9e3a8621d"
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