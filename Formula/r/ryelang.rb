class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.24.tar.gz"
  sha256 "ce9e0d6a1339404a7511bbf2713a4d1254db5ec49ea3b287ffd48743119cca60"
  license "Apache-2.0"
  head "https:github.comrefaktorrye.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c0788536ca1758c2cd3b4e7dc70afe0a293151335272f8a83fbaea6b386ef63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5c30420f9e7872ccb26a0fd415ee81bd39122ed1a22e2b391c63f5279bacb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b9702585780d7cd17810b0ecc50f2707a6e1ce19f8adfd8e3879aa8b0208d6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "205173d0bf89cc3357c5b39014e7425f14cc09a0cc9ae3acc0f871d2efc2e429"
    sha256 cellar: :any_skip_relocation, ventura:       "bfbdeaeef93402b954353ee58e61b7aa4fa375007546b6980fb4ec68b4d5c411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790e816fcd957f006077c9c8c954693aaa3df0bc798b81cc9fa9993fd5f0ed99"
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