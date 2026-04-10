class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/1.2.0.tar.gz"
  sha256 "59e7fe4db838af6ea10dbd760225d89ee242a7eca5589b7834b71d5bcdb69b10"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "013a8520ab38e7c8730263740355fa60fdb997d7fe7b8475b55ae9057a3b47d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03fb98db2ec108ff5c45bcf16b10912f824338c44579613d662a4fafed93d74f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34200b2cbcb8982b54585e52d9aa3b87c7d026dcb356c3fb188e83254f8eb1dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "48bcef947cc74681f5355a1fdb13ba9fad8bafc1fdfc59bcf85214782069f62e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "746e1042aa8824c564eacec1235174802cb3c2b7761f9f8299e2b69eca716889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d994ff988c035202e7efe21b4fd86aff35a02deed8edce6fa93c9dbe0e5334b7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end