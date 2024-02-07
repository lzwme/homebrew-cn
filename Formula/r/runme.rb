class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv2.2.5.tar.gz"
  sha256 "1e659ec714bd6fe4f1b0c204b07f5240bca3f9bb9bec6ca65ef7c525d7d05610"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39af0082efc5cbcac1b4ce13dd79d973bf95d7bcc03e1d6920ed3772ebe454b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b461e63a9eb78cf6d7a44bd402419b69f0b21fcb41b7d5da69f34e7dcd1ba58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98c2ea01efd674f5a090c2d6befeb644dfb52c26baf3c2a04e33a04eb253325d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d1ec7132ef78764e55f150aba8ac3a66fc24f530c2f432515e39d0e5f6a5026"
    sha256 cellar: :any_skip_relocation, ventura:        "6990d2d41a8bf69c05abdedc949d3891890c0591570f2779db2626664ecfe52a"
    sha256 cellar: :any_skip_relocation, monterey:       "d7eb338fe37527dcda5e4b3dacda3ea1ca4b63193c3cb1a2f72aec41417e69e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3fb8bae646ba9fa35831e09b0b414b9d802ae1305b83234976bf844b3fa158"
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