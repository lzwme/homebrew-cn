class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://ghfast.top/https://github.com/charmbracelet/mods/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "d8877258877408e90889385f1d3106278e71d56223e08e35dc60b120c95c903d"
  license "MIT"
  head "https://github.com/charmbracelet/mods.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d6a77c6fae2724572a0eca25aa00f98e7fbc496256f9c4f13c2aa96adf07fb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d6a77c6fae2724572a0eca25aa00f98e7fbc496256f9c4f13c2aa96adf07fb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d6a77c6fae2724572a0eca25aa00f98e7fbc496256f9c4f13c2aa96adf07fb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7eaae99ede15ebbe76c50e8d5f3648fc1b71bce725c8838ea10e702893cb368"
    sha256 cellar: :any_skip_relocation, ventura:       "b7eaae99ede15ebbe76c50e8d5f3648fc1b71bce725c8838ea10e702893cb368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83cfb78160e71b154cb9b047d42cc5d10bad3affa8fbcc5b0a735e540e73637b"
  end

  depends_on "go" => :build

  # skip db init for `--version` and `--help` commands
  # upstream pr ref, https://github.com/charmbracelet/mods/pull/543
  patch do
    url "https://github.com/charmbracelet/mods/commit/d18b03d0306116108d5bc50f58a4e81b6480cb74.patch?full_index=1"
    sha256 "b1ae4388376787219ebdc5b1be97b2222beb83043f467588ec48ead2154be342"
  end

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mods", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Could not open database", output

    assert_match version.to_s, shell_output("#{bin}/mods --version")
    assert_match "GPT on the command line", shell_output("#{bin}/mods --help")
  end
end