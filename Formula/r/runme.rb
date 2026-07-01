class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghfast.top/https://github.com/runmedev/runme/archive/refs/tags/v3.16.17.tar.gz"
  sha256 "7a499fe104eddf0493fc2a0105101898afa2184b654ab1e241e474d182debc47"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56b77003754beb4bc17d8fd8a8d9d2d9914cb33c808ff1338762d38e56f855b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dbc32435f87f6bc67bcc96621f7f56e369f8214e4300c6b9c131d7e677e411c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc964630902c8a1cf606bf740edb30f0a52eac6bcf92bc82a64c79aca401332"
    sha256 cellar: :any_skip_relocation, sonoma:        "8660b28fb4a0d3094b02017deb1d4d2b4f81c3c74bc8cd75b1bf0ff63b8a3c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91afef04b889bf4871de6b4e4ac6bea30c02985c71b3725589ddd807601235a"
    sha256 cellar: :any,                 x86_64_linux:  "f8b2f918ad33b6e2d897c4799c808d769adbe641931bb1a28274a3b97da07456"
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