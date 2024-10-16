class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.9.0.tar.gz"
  sha256 "6d355baa97a2e3876fceb2b3fe42249b2ff83703677cb8ae28ec963079a9a322"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2236694e928ed8135b080c69f42e161837f8aaa459856422d546749daa7db6fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2236694e928ed8135b080c69f42e161837f8aaa459856422d546749daa7db6fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2236694e928ed8135b080c69f42e161837f8aaa459856422d546749daa7db6fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "491cca0b246c5ed09080d122bc7bc680ab1711628f527d30b30eb65a87b7d755"
    sha256 cellar: :any_skip_relocation, ventura:       "491cca0b246c5ed09080d122bc7bc680ab1711628f527d30b30eb65a87b7d755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ade6102705080c01ff732ccd968e883b7cdec9c255d74c3dcfdce95256afcfa"
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