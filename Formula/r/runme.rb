class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.9.2.tar.gz"
  sha256 "80ba7a64a37ed6696fb7f9015509185e13fbd662706854b1e7ad955182a0b3dd"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ca62eaecb5e69417a862c20af49bfeec00961ffc8c38c237f6e1fe87ae5b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ca62eaecb5e69417a862c20af49bfeec00961ffc8c38c237f6e1fe87ae5b77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43ca62eaecb5e69417a862c20af49bfeec00961ffc8c38c237f6e1fe87ae5b77"
    sha256 cellar: :any_skip_relocation, sonoma:        "b92b8b63d52c5f50047826d7bb3e73bf378bcb5a52cf7008ff17518e3d7dc002"
    sha256 cellar: :any_skip_relocation, ventura:       "b92b8b63d52c5f50047826d7bb3e73bf378bcb5a52cf7008ff17518e3d7dc002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b57cb251303090585ff79c116fd9b72c104fbb9740c3830c7cc2f3658e0f983"
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