class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv2.1.0.tar.gz"
  sha256 "a4b4723416605236b2ffc38ce10468d57e2c540914ab161eb4acb52fd69bc776"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "886d71d5e46fa6c08165c679dcdd0fe226fefbf8d4a3e1e760a145c1fef90aec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfd97fb7631da23b56606c7ad65a49ea8957769857e391d4d79543f28a46b7a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66bc910dd0410e3dd676bfeef716e10b6281d735a01dc6c4edc668c9a2b9b3b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "51b7efc1c7813cc3ecf68dacc029dd7036b371046dbc2d8854010ce0bc298e73"
    sha256 cellar: :any_skip_relocation, ventura:        "41feb1d153294bd0bb2914ca4427e5250de4018c55317c05ed642bc286616e49"
    sha256 cellar: :any_skip_relocation, monterey:       "38589413e12dea0418ff59bfe91d2215b41bf2719bd22c2f4656fda04e267d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d1cd2ec052e94febd4eaf40e02cf2b114c584d0820a6448226b8fe24a2c1a87"
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