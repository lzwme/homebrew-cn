class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghfast.top/https://github.com/runmedev/runme/archive/refs/tags/v3.16.2.tar.gz"
  sha256 "b33b8630ab5be9013d28a84f8d46ebb79267b366ef57cd8d4a2a7a8796390ca9"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "197df6a49db023732e61fe0d12a981c7a590d18e527b9ace5c874459411e1d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9fdaea4cf6b64ab15d268e56bf8f9910f9ab2667c42af88306def69a1d590e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56992245dd6f19e6651d40ddc5ff5a85d44a837a54cae9bd3e0da6330927951e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a13f4939448c371075bf2b95f1aa953b00ad9cbf983c21693f2645b191437319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a260ba115a52960c984b035573ab69b707080f18074413a19d72455a38d7a578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5d3593ca0e16dbd3a90148cc6029540e62b0c87783352007b0932c7ed1785d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end