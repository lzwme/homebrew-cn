class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv2.2.6.tar.gz"
  sha256 "ee0f6be2c40c7558eb8fb17bfed6d03f513d39092528221ec4d39afff2393ce9"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92a40de1dcb7c34d6d921cc9fd35728d30b479d019abba90cf4437b831adace4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02990ea829c40c03002a5ec7a4fffa78912c0c680638a659d8aae0579b3581d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9813d8492ce51ffda2712af6fa460880e7a7eb6521a31c9ab68324850e678b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fce4d82bba1652e27ddfa5b41a973fe4c6c6b3de3dabeb0ea87adcbf1236590"
    sha256 cellar: :any_skip_relocation, ventura:        "f4ee8826fc5df114f6d22e45a9002f66027ea701371cfbf15a33366f196d6db7"
    sha256 cellar: :any_skip_relocation, monterey:       "744a20df89d99565735abd1e77b63e59f589579edfef854fe687752ad4b18ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44478bbdc05e0ab2470aa641b711b72bc561d24fd497a09722c7dbe681ceb4a9"
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