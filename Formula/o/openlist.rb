class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://ghfast.top/https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "9cb26d5a41a9df56a6c937bc37a572ff104e2d5a72c0ec8813273f2e67c0a092"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f038b34ec22fe8a8ea2e086a9b54610e77c9a354b63f4eb53a719ae0462da4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4445b0c149b979b183b0ffbffa00985c9b7d189df805cbf3c41d4a68601b64c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa183fd7280328392f2c5a35a226cd736d8ecf1d46964d6fbb273fab1d63833d"
    sha256 cellar: :any_skip_relocation, sonoma:        "84dffae4d030e0739f6b942ab7695ff0de42bde086e7d023f050a1a0970f5b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e04c99fbb9f2005a2ef2dece35b3799b8d6f323ee924fed90cef5f94223f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e3b264448b796fc21b3529cfc69f781020e06e564ec3fc2efd9c7b4b9242cd"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://ghfast.top/https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.1.6.tar.gz"
    sha256 "6bd3f5b2b28578d6047753eba8315516e8747d4bc5262817fa2cc9ba96490bad"
  end

  resource "i18n" do
    url "https://ghfast.top/https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.1.6/i18n.tar.gz"
    sha256 "72d2974c615a896948af4db63b4cef5b4d74247ef317501d4c9028e029b5acf6"
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r buildpath/"i18n", Pathname.pwd/"src"/"lang"

      system "pnpm", "install"
      system "pnpm", "build"
      cp_r Pathname.pwd/"dist", buildpath/"public"
    end

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.BuiltAt=#{time.iso8601}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GoVersion=#{Formula["go"].version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitAuthor=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.GitCommit=#{tap.user}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.Version=#{version}
      -X github.com/OpenListTeam/OpenList/v#{version.major}/internal/conf.WebVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/openlist help")
    assert_match(/Version: #{version}/, shell_output("#{bin}/openlist version"))

    test_data_dir = testpath/"data"
    pid = Process.spawn(bin/"openlist", "server", "--data", test_data_dir)

    max_attempts = 10
    attempt = 0
    http_status = "000"

    while attempt < max_attempts
      sleep 3
      http_status = shell_output("curl -s -o /dev/null -w '%<http_code>s' http://127.0.0.1:5244/ 2>&1").strip

      break if http_status != "000" && http_status != "000s"

      attempt += 1
    end

    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    refute_equal "000", http_status
  end
end