class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://ghfast.top/https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.8.tar.gz"
  sha256 "9b3ecb32ab23ecc79a0d471cff3e62a50a93a52fa79245cb6cfc38994546a606"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4a89a567eee82236d660c57f06dc159baf4b18a2fda8b9b8e1d881cabf246aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d452ac621d05f6cddc526fb5d9a58520e9644468de477de7ed326ae3b9c80afb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9604f7ebd274e085e59231f6bc70604243af769ca561c55227db5372d23badf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97fa0b6b78cad7a89e5321cb66cd8ac3341b5d1c9416db0d5745ffa1bc237b0c"
    sha256 cellar: :any,                 x86_64_linux:      "6c0631c557ff7c6b3601fd86e08d051ac28f497255d75ee270de4e512480ab1e"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://ghfast.top/https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.8.tar.gz"
    sha256 "69d16c6f14309e81f38932cfe8e1532f2f988e791f0ff3b6beacb0ff53d1aacc"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://ghfast.top/https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.8/i18n.tar.gz"
    sha256 "d9dc86471f559257bc1eeaa9c74bcef895836f6d5d3bad0f773e71e47633d75c"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :test

  def fetch
    resource("frontend").stage do
      system "pnpm", "with", "current", "fetch"
    end
    system "go", "mod", "download"
  end

  def install
    resource("i18n").stage buildpath/"i18n"

    resource("frontend").stage do
      cp_r Dir[buildpath/"i18n/*"], Pathname.pwd/"src/lang"

      system "pnpm", "--offline", "with", "current", "install"
      system "pnpm", "with", "current", "build"
      cp_r Pathname.pwd/"dist", buildpath/"public"
    end

    ldflags = %W[
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