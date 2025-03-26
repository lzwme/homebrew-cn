class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.46.tar.gz"
  sha256 "11f01313485a5ea84b1c6f7ebc494c2cab830b52966900ea08a4ba45ddc47d0b"
  license "BSD-3-Clause"
  head "https:github.comrefaktorrye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4a3fc33a43608220b3eccf96f0478830345a09be423b6e4e226d0ea04c0dc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c65d0a797f3f8ffaee824f262a336b479135633dccf2e3b0c039944f7f214e4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ce2b912cf5e578c137a814656225afc49a490befa37a43094a357f9512eb2e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f664675975bfe2599fdf1e1ca4c1d815e09daa64083d6fdab2a8352a8aafc2b"
    sha256 cellar: :any_skip_relocation, ventura:       "a1eef2b1284e8080b88c19825ac464ceb4d38f8d2aae115d86452667153f9ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3ae69d6b14e99ca4f3739b142f8fb58bb878a2abb356d82d33489d519b19754"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    (testpath"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath"hello.rye"
    output = shell_output("#{bin}rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end