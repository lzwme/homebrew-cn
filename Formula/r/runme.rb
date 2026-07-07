class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghfast.top/https://github.com/runmedev/runme/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "9823f4b9c2efae53edf24b515b2b43eb0c98d57e1639def3c3b521c9579f01ae"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffa90c91d46a0f1c2de1b9cae914fa2ea5dcf6c0e5e519c1c2b2019a1890272f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d704c785985cb51a89d41ca57d262b0d8124e84f89daae379c3aaf268d3b1592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c19e7a5f3317f3f58a74f4bff1e7fc419c88f3c317a8ad470b6f00b1a31bbd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eadb18f00e09fc1328be68225ddc28955257fad0cef3d56bdc0ebbafc2cb6a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1243f650e22de59782f475677a06624ad3bfab8f1c45017372840b67fc285cef"
    sha256 cellar: :any,                 x86_64_linux:  "f083d0932d6c4840d6469c3c2a500596823ff558bc508b84d3cb3736b9b99985"
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
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
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