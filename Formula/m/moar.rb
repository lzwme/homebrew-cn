class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.27.1.tar.gz"
  sha256 "c11056b36b7574b9a02fd8881121b34f2d809acb674d367755e3a23ff550fa2f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f13259b26d28f484ff96c5fed39b32198a79fecf8ef884e271cd4ea7d59815a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f13259b26d28f484ff96c5fed39b32198a79fecf8ef884e271cd4ea7d59815a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f13259b26d28f484ff96c5fed39b32198a79fecf8ef884e271cd4ea7d59815a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b2e4122cedf19de2e7a920cd37394788c1dde8c3d61f612235c2e3ed231e31"
    sha256 cellar: :any_skip_relocation, ventura:       "d3b2e4122cedf19de2e7a920cd37394788c1dde8c3d61f612235c2e3ed231e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ffe7fa2dc2a6baa08e50e0c5330dcef7f6fd04ee5ff30da67989b55e8eed06"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

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