class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.6.0.tar.gz"
  sha256 "5423d83373d30efdfeef7c3c008bf84d3a1ae245282dc23ba894e7f3bf80cea8"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc6e06f50303a9f8690a5b89fb5caec6873b929f296f6c685802449d15f9eeff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc6e06f50303a9f8690a5b89fb5caec6873b929f296f6c685802449d15f9eeff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc6e06f50303a9f8690a5b89fb5caec6873b929f296f6c685802449d15f9eeff"
    sha256 cellar: :any_skip_relocation, sonoma:         "0383d33d8256a88167dba3bb50ce7ad9fb695dfbadf7f21513e0650e20482cb0"
    sha256 cellar: :any_skip_relocation, ventura:        "0383d33d8256a88167dba3bb50ce7ad9fb695dfbadf7f21513e0650e20482cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "0383d33d8256a88167dba3bb50ce7ad9fb695dfbadf7f21513e0650e20482cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523b2073c0ccc6bef03226d2d0e1eb4370a7df30214a6c26ff2a940a6288ca28"
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