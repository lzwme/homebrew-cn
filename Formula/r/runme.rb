class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.3.0.tar.gz"
  sha256 "5ab7ba037b076787fcd2835984aa080fe64ccfd22345ae4bb95589ea3a338655"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93fa3653be0142983cb1ffd512ed65c088cfa6e758bc2a154ea624e3390f2851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0965e2f12286061881f0673c9473d511c8bd7b40e7b672f4feb36d462d1b6738"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c3fb5515d861aac886ab491e0559e3a6cd76543d85aa1a38de9c7b6cb5f2e72"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c56d7d90ee52023cd48c865b992c11ca1be5753dc86a54274dee639455bf8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "250d2921a841d483f7152d7c396c050a3b33029fe88094cbd612fbd72bb9c029"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ba7dd660060f338cdf6dfb4d8d077a2deb225cb782ca3f270798190ee81aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9fc25ca3fdb99cb1caa2753f38e0938898d67296b9cc16f025cdd2dbca677c"
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