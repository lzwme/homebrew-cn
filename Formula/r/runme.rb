class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.4.1.tar.gz"
  sha256 "3b30dfb81ecd68096d71dcfc83e8442b0adfc112824264d76e4a5e4249b9f1b7"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4ee094e35a1f25eaf11b50a2f1157e3d37f2d25274a9027c75a6af15dadd407"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac12816cccc058e86947a8c466c6ed27b62ed00b5da54385649cb66e92125166"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bfcb9031f1ce6022bcafdbd06d293467be978139dc20c049e3449dc8ecc2ac9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ecce55b17a76b5aaa6beed92ef9538c2716e840d8f7cc14c3c95aa1d695ef4c4"
    sha256 cellar: :any_skip_relocation, ventura:        "54d230cebf038dc0da01b80303a0566c2cd3fc793674d85876739e8d3e2f7736"
    sha256 cellar: :any_skip_relocation, monterey:       "cb72647cfb4f83b35e98ee8ee3a7c877e588d083c8c21318554e967b159d926a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c521eb8bfe789ddda96e9d25e9140ab87472f12682998b5483f526cb78cf82c8"
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
    system "#{bin}runme", "--version"
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