class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.33.tar.gz"
  sha256 "b932a734f97cfb1e9f46a6cd110c586a083aba99f4a14784712358cb6fd7131e"
  license "BSD-3-Clause"
  head "https:github.comrefaktorrye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2016dfbcfcd9295dbf6340087b7bbc1a3767c5832a1518d1ccd5cc0d478078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "026123e82f5387c00bddc5b2555467e5f63fa2c23af8d2e1212470640f816ce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dce6c00e1e944011f2111b106abc6e9a7ee305f3deb48de78d5681f63dd28ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be9b573665c4b38c570ce40633bdfa664f02b975d89d26f41a8506483561d90"
    sha256 cellar: :any_skip_relocation, ventura:       "322f268858ec889b94f211425f6aafa63d08a197fa96ce2f01d6da75e1e274c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a6460dc90e8799d2de10cde822bf83a461e0e20cee90e45d6c69d626c1ef25"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath"hello.rye", :exist?
    output = shell_output("#{bin}ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end