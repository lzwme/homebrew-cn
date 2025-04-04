class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https:anubis.techaro.lol"
  url "https:github.comTecharoHQanubisarchiverefstagsv1.15.2.tar.gz"
  sha256 "d3412918872d0e3fe95091953c23be860c81b289ec4c00f94ae090037b69a885"
  license "MIT"
  head "https:github.comTecharoHQanubis.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe2b3ac54d14ed56ac6e0bbc52b6fde1361975ed4edb4b84494cbbef67ee4e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f46fb664400f246a20f62b12f7c67b0ba924b8fa8733b3806c25f5a5e76a424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ea03df6d20ad735ed7c82a254e40942020d95edc0122c4790cb1f9a7f17a6b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2160b056ea45d3713a7ab7070f465bd6c35a1139b5715286035d75bca0663e5f"
    sha256 cellar: :any_skip_relocation, ventura:       "a6f23a3559a78bf64e16fe7895c9b7e192291fc68ef18e686dc0f9e5d4d352ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807fc6a3ea23b734ad90357b65832657f820fecff43c5ac973a8a219929e559b"
  end

  depends_on "go" => :build
  depends_on "webify" => :test

  def install
    ldflags = "-s -w -X github.comTecharoHQanubis.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdanubis"
  end

  test do
    webify_port = free_port
    anubis_port = free_port

    webify_pid = spawn Formula["webify"].opt_bin"webify", "-addr", ":#{webify_port}", "echo", "Homebrew"
    anubis_pid = spawn bin"anubis", "-bind", ":#{anubis_port}", "-target", "http:localhost:#{webify_port}",
      "-serve-robots-txt", "-debug-x-real-ip-default", "127.0.0.1"

    assert_includes shell_output("curl --silent --retry 5 --retry-connrefused http:localhost:#{anubis_port}"),
      "Homebrew"

    expected_robots_txt = <<~EOS
      User-agent: *
      Disallow: 
    EOS
    assert_includes shell_output("curl --silent http:localhost:#{anubis_port}robots.txt"),
      expected_robots_txt.strip
  ensure
    Process.kill "TERM", anubis_pid
    Process.kill "TERM", webify_pid
    Process.wait anubis_pid
    Process.wait webify_pid
  end
end