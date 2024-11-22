class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.9.4.tar.gz"
  sha256 "664ac958b9f690c082f65c09a114e684954eb1f41ffd945b093a966134f09dd1"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be7c2eedf1789f2b66dae21ef846ce10e9c50ae2627714a2c373fb2805ffa57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be7c2eedf1789f2b66dae21ef846ce10e9c50ae2627714a2c373fb2805ffa57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4be7c2eedf1789f2b66dae21ef846ce10e9c50ae2627714a2c373fb2805ffa57"
    sha256 cellar: :any_skip_relocation, sonoma:        "138a176eb562d58afdad08fc0942c0aa8ab4618c86edae6c96ac263fd6f83e92"
    sha256 cellar: :any_skip_relocation, ventura:       "138a176eb562d58afdad08fc0942c0aa8ab4618c86edae6c96ac263fd6f83e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a7d1d4d8d868b27c812f38a810b6f4098d5903a04edf6739253a7214b532d91"
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