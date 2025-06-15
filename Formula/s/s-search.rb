class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https:github.comzquestzs"
  url "https:github.comzquestzsarchiverefstagsv0.7.2.tar.gz"
  sha256 "d36474448d9594743ff8841585e596c24ef0be9110f15e6b39baa96c8d982e6e"
  license "MIT"
  head "https:github.comzquestzs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd28347437ccaac577e520058f36e31995d1fa406e7e4b17f5eee109d38313a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd28347437ccaac577e520058f36e31995d1fa406e7e4b17f5eee109d38313a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd28347437ccaac577e520058f36e31995d1fa406e7e4b17f5eee109d38313a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3952e5a7149cb4d195c85f551fa781a372b54d8890a1a645371a5811bdeeb90"
    sha256 cellar: :any_skip_relocation, ventura:       "a3952e5a7149cb4d195c85f551fa781a372b54d8890a1a645371a5811bdeeb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "962819056e6fd782f24e136064609ab9ab5e4fe20b0e8efda38969f685e4dccf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"s")

    generate_completions_from_executable(bin"s", "--completion")
  end

  test do
    output = shell_output("#{bin}s -p bing -b echo homebrew")
    assert_equal "https:www.bing.comsearch?q=homebrew", output.chomp
  end
end