class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "9b5ad053a30644649e220f7496a9a80c497fa0551258f52bd0398695d967eeaf"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92c68637f537d233d5d07e0d5b84ac78a8ec1ca7f660bf268b7e5aab13f9392c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86e4358d6f2379fda9d15512e185fb1d4b17a20e1ee1d48e6385c88253656a94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "511dfadb29836f4268795b846b003f3413a241a5b7061b53ae5a45f6610f6bcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a174e0e67cd2b44535483d7f5787fe8d1893922539a1d251b388c73ebc8faef"
    sha256 cellar: :any_skip_relocation, ventura:        "092c7669a5a5ba9708d7e24ae5a85fbf24e10736f68036fad6d0f58d4375d562"
    sha256 cellar: :any_skip_relocation, monterey:       "0916b35d78f3e6a6a52133038f356e287b5bb339cc57e20022bf9ef10e7527b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b62240ff10328e8f9bc03b33da11f5d80bf4fe9c5531b81ce8b449f9aeb8fda3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end