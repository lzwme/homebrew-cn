class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.22.0.tar.gz"
  sha256 "c7c6f2edf5569068e51656742cce373931798811ea6ab13f6db9659fc3f4fa76"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b96e5f6f907dad570638d26985a29547edddd2c7495686f664b7f7e960c8d89b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b96e5f6f907dad570638d26985a29547edddd2c7495686f664b7f7e960c8d89b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b96e5f6f907dad570638d26985a29547edddd2c7495686f664b7f7e960c8d89b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2fabda6dbf4ed1ae79a7c1995f4e5c8bcfe4ac12e66e9f6fdb5dd8eda17fa53"
    sha256 cellar: :any_skip_relocation, ventura:        "a2fabda6dbf4ed1ae79a7c1995f4e5c8bcfe4ac12e66e9f6fdb5dd8eda17fa53"
    sha256 cellar: :any_skip_relocation, monterey:       "a2fabda6dbf4ed1ae79a7c1995f4e5c8bcfe4ac12e66e9f6fdb5dd8eda17fa53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0472c0a1809e82e1d10538ca233fe1954781d4e3ad637733853f3592a822846c"
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