class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.6.1.tar.gz"
  sha256 "991adfc898afbe43b869233b9dbc2fab0b579ac48d00b1f040a6e89c765d4856"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e49e5e02a7960b53a3028fa25be411aaf28975f0a597e5831e1ae07bf0c269ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e49e5e02a7960b53a3028fa25be411aaf28975f0a597e5831e1ae07bf0c269ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e49e5e02a7960b53a3028fa25be411aaf28975f0a597e5831e1ae07bf0c269ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "7543afd1e67ac584ddc4589c64ff6e39c2a9ef14335352b49aa26bcff1f94949"
    sha256 cellar: :any_skip_relocation, ventura:        "7543afd1e67ac584ddc4589c64ff6e39c2a9ef14335352b49aa26bcff1f94949"
    sha256 cellar: :any_skip_relocation, monterey:       "7543afd1e67ac584ddc4589c64ff6e39c2a9ef14335352b49aa26bcff1f94949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0c00a8ca71a398ab96813b205d8e0d900a197f1a38d5aae18bb24cd26985bb8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system bin"runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}runme list --git-ignore=false")
  end
end