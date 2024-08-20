class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.5.2.tar.gz"
  sha256 "fc09268fddcd6d30a1f7f34237cb6482a891dd8c3bb5982a44b94464ee71e50b"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5174256b5a200a35559141951c0ed4853de4ee6f2f8ae90d52b01cb97420ff54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5174256b5a200a35559141951c0ed4853de4ee6f2f8ae90d52b01cb97420ff54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5174256b5a200a35559141951c0ed4853de4ee6f2f8ae90d52b01cb97420ff54"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3c31d1dbec385bd1fef76de1b3fd4855a7f095108c9fcdf0bc01baadf550278"
    sha256 cellar: :any_skip_relocation, ventura:        "a3c31d1dbec385bd1fef76de1b3fd4855a7f095108c9fcdf0bc01baadf550278"
    sha256 cellar: :any_skip_relocation, monterey:       "a3c31d1dbec385bd1fef76de1b3fd4855a7f095108c9fcdf0bc01baadf550278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a989d6308d9f2fd2d4109cd7517b5325f3d5f0366266423a74020f146cb41177"
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