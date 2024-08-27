class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.6.2.tar.gz"
  sha256 "08421ae49806f6fd6f733238487cf526070511b13390a6377e573a443603e928"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "857151dab49b08e4fb773fec94398cfa3587442269ef12b80dab926450245e29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "857151dab49b08e4fb773fec94398cfa3587442269ef12b80dab926450245e29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "857151dab49b08e4fb773fec94398cfa3587442269ef12b80dab926450245e29"
    sha256 cellar: :any_skip_relocation, sonoma:         "2de51672babfee45b02fac0e2f26d72dbb8fdc26a4a551eba1eac88e4c9aa87e"
    sha256 cellar: :any_skip_relocation, ventura:        "2de51672babfee45b02fac0e2f26d72dbb8fdc26a4a551eba1eac88e4c9aa87e"
    sha256 cellar: :any_skip_relocation, monterey:       "2de51672babfee45b02fac0e2f26d72dbb8fdc26a4a551eba1eac88e4c9aa87e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "936e42a5c7650ba3904f50265a8a60c709d1b087d86c87568a6092a8386c7a4b"
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