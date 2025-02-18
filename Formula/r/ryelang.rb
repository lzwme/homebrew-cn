class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.35.tar.gz"
  sha256 "f631c436f4b1cad3c37926cdb7f8dbcf5b5a7f49ad73ff0f0091951396b24569"
  license "BSD-3-Clause"
  head "https:github.comrefaktorrye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a432d2e511323723817e6a68c078f6cb5289190f63d4b0ba27f88813bbaa33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3853f9ecb110538d7f76f979ccb4bf5ae2283fc7ce6b892d94a6507ffbafc492"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7eee16627c5fe1b68ceb72282bb21e8f39ac832166cfccde36727651f6575a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04e924ffaf07a42e8894363f48ac5f548e967604931c46d8ef94360453293b0"
    sha256 cellar: :any_skip_relocation, ventura:       "408005e650a03f2b4b4498ae89a9d1c3128a9f7dd30adbf77dfa74fa4be8f33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d0202d3f24cbcccdaf858792ad21476f35d8fec51a37710877f24cc4c8f2a9"
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
    assert_predicate testpath"hello.rye", :exist?
    output = shell_output("#{bin}rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end