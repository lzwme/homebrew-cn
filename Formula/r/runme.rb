class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.12.4.tar.gz"
  sha256 "e703770d4c073c8973ae2249e498524544146edb794ca614cb7059107372460b"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80586fa7074496d9651a34196cf213f4d8c2c5023b49c29af6a3296c30d1336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80586fa7074496d9651a34196cf213f4d8c2c5023b49c29af6a3296c30d1336"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f80586fa7074496d9651a34196cf213f4d8c2c5023b49c29af6a3296c30d1336"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab78a9108a3cd04d316919178433c282334985d0c46afdc0f9735670cc8cf0e"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab78a9108a3cd04d316919178433c282334985d0c46afdc0f9735670cc8cf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c3875920404ce1581ea422308203e18ed64ba36e076389f47ea1a4249420c2e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system bin"runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}runme list --git-ignore=false")
  end
end