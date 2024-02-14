class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.0.0.tar.gz"
  sha256 "425996ca35df05c7d16dc85f686ed231b3f3a4c77289a9ef333f5e65c3fd5d79"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0925fc5ac413970dcc3e4099ca387f0bf160d11e6d4e841fef33803aca75791"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0c0f15a1b3626b494cc3d797e93eeb4fa73d292c40e2f60ccd70563762482c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8aa4027845207e4637cdf4281aa69a34bb0f7fd37bcb9b2f5f7bfe68d0080ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d43598c1a71e7e6c4a3617bf807a98bbbd21807dbd57bc0b8b6cbe5f2e597b6"
    sha256 cellar: :any_skip_relocation, ventura:        "13c1938c3e85eca4757bbc7b52a0402481ef87344e8312ed9788f962e6014b92"
    sha256 cellar: :any_skip_relocation, monterey:       "a547e5ea49f693b422473edd0e75e1564cf1c4c45d1385c8e63d852f3689474f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fc6790099419ae4941673fafeb1cdde5b3a7de870d19ac47560d8590809b7d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmeinternalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmeinternalversion.BuildVersion=#{version}
      -X github.comstatefulrunmeinternalversion.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system "#{bin}runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}runme run foobar")
    assert_match "foobar", shell_output("#{bin}runme list")
  end
end