class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.3.2.tar.gz"
  sha256 "368b1136089cc60e0383ef4d20d82e7b4c2ca6843b0593ca92ccad0400907ad2"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a32fa07fb83627c282713c3ade14601b25cd7f967a9f4668a4f3324608a1c132"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20e7cdbba9efe7081a0af9bf3080b024617dc80866c44231efea4ebc4e6cad82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbcca62ceeae3dde32b96194fe35587631cac863c814149579f80fe38e7fceea"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a5f695852cca4869c024d8932a18090a386ee05a68338205f7f12212eac53eb"
    sha256 cellar: :any_skip_relocation, ventura:        "ae065c4a302d63313122ba2cd48a0b7d46a22078bc4a8c988310b20bf560c0ba"
    sha256 cellar: :any_skip_relocation, monterey:       "37a96c7d9759f1bd4e55cef66628a76786b5c8b60d757fc1b110cc9a7574adc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d03ab6469e3027ee4384e04baf41bbfc67cff27bd66eaf97bea9d750aa4be09"
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