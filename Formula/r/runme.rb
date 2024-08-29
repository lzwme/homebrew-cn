class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.7.0.tar.gz"
  sha256 "1ae352087535ac6678a72b7c03d232ce91896a8f0944754b81f06ce432aa8308"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "028623e19df58798406f6f8f622549021b971244bbeee1986006a232aa21b106"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "028623e19df58798406f6f8f622549021b971244bbeee1986006a232aa21b106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "028623e19df58798406f6f8f622549021b971244bbeee1986006a232aa21b106"
    sha256 cellar: :any_skip_relocation, sonoma:         "16c04dd93cea06c614dacfd7cab5a8399dd84702ad021ecef65bc7734d52628c"
    sha256 cellar: :any_skip_relocation, ventura:        "16c04dd93cea06c614dacfd7cab5a8399dd84702ad021ecef65bc7734d52628c"
    sha256 cellar: :any_skip_relocation, monterey:       "16c04dd93cea06c614dacfd7cab5a8399dd84702ad021ecef65bc7734d52628c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1836ce4aa7514225b1d569025834706c3b8b0a3792143374a9a35b7654408d8"
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