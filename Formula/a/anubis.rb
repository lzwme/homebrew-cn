class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https://anubis.techaro.lol"
  url "https://ghfast.top/https://github.com/TecharoHQ/anubis/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "4ae64e7ae54820059f64083a2f87e8bbb6504d8159b541647150cc83c58377c5"
  license "MIT"
  head "https://github.com/TecharoHQ/anubis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f5e322854ca7cb1cb96d27160d69ba2971c333023376428ac3e7546b2118f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64561e092adc6960bb14127aeef9d69ff24fc5f8dfb3611f14fdba7177149b92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1824dcea57b2b459276f116a1ce6de5a75d44991c7d5585a6e77c90dccdae22c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a9e838f1b662daaa6895f90d2022e8312bf3806d391b85937cad69e2d8d85de"
    sha256 cellar: :any_skip_relocation, ventura:       "429e135421bdd7a80826e81f5363d53c3b7d6d6af0f0866ba9ac93b710eaeaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1adb5648d51daf749489755564d2f5313eb9befe14d525e3a82c452b7c026be3"
  end

  depends_on "go" => :build
  depends_on "webify" => :test

  def install
    ldflags = "-s -w -X github.com/TecharoHQ/anubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/anubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn Formula["webify"].opt_bin/"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin/"anubis", "-bind", ":#{anubis_port}", "-target", "http://localhost:#{webify_port}",
      "-serve-robots-txt", "-use-remote-address", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: /
    EOS
    assert_includes shell_output("curl --silent http://localhost:#{anubis_port}/robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end