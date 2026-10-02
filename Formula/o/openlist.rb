class Openlist < Formula
  desc "New AList fork addressing anti-trust issues"
  homepage "https://doc.oplist.org/"
  url "https://ghfast.top/https://github.com/OpenListTeam/OpenList/archive/refs/tags/v4.2.6.tar.gz"
  sha256 "028694b14ba7368429774f33c1b7eb584b2bf6235fb7d72df371e528a5c6b04c"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4148b6ece625bbe8750933de4640c26037a02070534b100fe42fb359005665f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44e01e11158ce33709dd9299112aca9e652c8d8d949fa97a83ca7daee2c94f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "277e49803c3b4100edb8ef97397f6e70af42bd2259168907e28c0a5a7229abe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0395f4a9223d483d01f7dad1d8aa6362f5302aa7ed8b26dc2133df4675ec7e6d"
    sha256 cellar: :any,                 x86_64_linux:      "5d07ec9fa47cb4d533c93555c2ce1cc0690c1bed06799e7838240822e5dc83fa"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "sqlite" => :build
  end

  resource "frontend" do
    url "https://ghfast.top/https://github.com/OpenListTeam/OpenList-Frontend/archive/refs/tags/v4.2.6.tar.gz"
    sha256 "fa613bd495cd7708c22a3c511145e5a517c920eb6067513c74762ca15dfa0f3a"

    livecheck do
      formula :parent
    end
  end

  resource "i18n" do
    url "https://ghfast.top/https://github.com/OpenListTeam/OpenList-Frontend/releases/download/v4.2.6/i18n.tar.gz"
    sha256 "de3160d4a784666002ff632e77c1653bbff32358a81377a1c964e6a29e306556"

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