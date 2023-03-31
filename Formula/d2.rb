class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://ghproxy.com/https://github.com/terrastruct/d2/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "28901237ad0c16b49c62a89c6246dfd38dd245e530d25fc74dca1fe2e3b9348f"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3f314d0484c0e4f35a0d853565413ac6093476ee7bbc66194eb2bef138683c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3f314d0484c0e4f35a0d853565413ac6093476ee7bbc66194eb2bef138683c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3f314d0484c0e4f35a0d853565413ac6093476ee7bbc66194eb2bef138683c9"
    sha256 cellar: :any_skip_relocation, ventura:        "4432206c116456ee7eb53ee7d388213896e1567011117bd88562cad3c16d3a21"
    sha256 cellar: :any_skip_relocation, monterey:       "4432206c116456ee7eb53ee7d388213896e1567011117bd88562cad3c16d3a21"
    sha256 cellar: :any_skip_relocation, big_sur:        "4432206c116456ee7eb53ee7d388213896e1567011117bd88562cad3c16d3a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9331f83727a4c9229a8885146ddb4834b7f53b0e5d30bb8c7dc738bed11c709"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end