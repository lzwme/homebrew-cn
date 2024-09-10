class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.7.1.tar.gz"
  sha256 "9a5938c9f1954bd86fc49007be597da2e189b4e0ac81086bbae844e13e4b2773"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6289aef1ad01ec605c26dcab2b1c581a8535a8e33d35381db5a391c0d22b51b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6289aef1ad01ec605c26dcab2b1c581a8535a8e33d35381db5a391c0d22b51b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6289aef1ad01ec605c26dcab2b1c581a8535a8e33d35381db5a391c0d22b51b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e188705e1ca23497af7f8fbcdbb710263ff61bfc3251b09030417e8bc34c1d07"
    sha256 cellar: :any_skip_relocation, ventura:        "e188705e1ca23497af7f8fbcdbb710263ff61bfc3251b09030417e8bc34c1d07"
    sha256 cellar: :any_skip_relocation, monterey:       "e188705e1ca23497af7f8fbcdbb710263ff61bfc3251b09030417e8bc34c1d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a197b833b59f18075bada2b174a97f7bec40852a13517245ed2242ec9a86744"
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