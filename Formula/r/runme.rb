class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.10.2.tar.gz"
  sha256 "89f3271cb40b234de2a63527d7b3d5f0cadac45e5a55bd73a65779b2a21c9aab"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0a2570a9dc354dd653743ef4642ae6995ad68eb03c5be068c68c472d16a5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0a2570a9dc354dd653743ef4642ae6995ad68eb03c5be068c68c472d16a5ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a0a2570a9dc354dd653743ef4642ae6995ad68eb03c5be068c68c472d16a5ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "12d7563f8640756d1fccfcc7f59837d51bc0bd4335d4c4f6b0f1d9339e35cab6"
    sha256 cellar: :any_skip_relocation, ventura:       "12d7563f8640756d1fccfcc7f59837d51bc0bd4335d4c4f6b0f1d9339e35cab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71cba60f146abc0807f427f3d0e500514aba35895d7e8c4048906b2fe0964c48"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system bin"runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}runme list --git-ignore=false")
  end
end