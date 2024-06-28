class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.3.5.tar.gz"
  sha256 "a8867c14e061048414ec669b5bb9d99fcc43a7222d4e0fb83e88922181902e69"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3f28ae13a662c39f2e067412054cdbd4bd41c8944752a68b3900eb490c12f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3401f2180bd6a1cd69d36c5117d7c9786f0514fcf11d8671ec07328170c8d084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6232e7590b4ed8c70b7705ca8a252277875600a03d4367e551f69e7efbfa75fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4a39810328f90f661b434db0712e500a410437f56b43a98c965055bb98df15c"
    sha256 cellar: :any_skip_relocation, ventura:        "68572a424b6b55adf03b551d95cc4fc86df08a80ae9c58b47dd373447b254f87"
    sha256 cellar: :any_skip_relocation, monterey:       "6a95b6f56edb55093865d874352f856d03354f4367421ca495dee81bb5401038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848d0c8683dbe44f93a31aa0ae832206ee53d1857b64bce4ba1dc4d0eb680301"
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