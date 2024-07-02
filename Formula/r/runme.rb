class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.4.0.tar.gz"
  sha256 "c761f2709d4679f661962dcc2eac644ae24ae42786943486568ea96e6880f7fb"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00e35ecc313e633d75d6c90748060aea9258298efe13b4bae553d863f31f6f09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05572b81b375a6ea88718066f37b091e60665d2b83037809b70af755258fe4e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b41472374bbae8e8fda12758576d651fc232894136207d6ac41ab70ba6336582"
    sha256 cellar: :any_skip_relocation, sonoma:         "4648395589930230bd1830282a908eee29e4af9a9508e7d5cc049ae5b22ce74f"
    sha256 cellar: :any_skip_relocation, ventura:        "50bc554537896936a745759df7e56c66e04f63d0301b9e86b8ba3ecb0619db9c"
    sha256 cellar: :any_skip_relocation, monterey:       "a92640b296b4bdf647e391a5e7332aad440da2881a7dc82ecd0989da997b1033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3aea97df6ca0d6524bbd39ecde2150c711be49abe258335afb7330cf08ae02"
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