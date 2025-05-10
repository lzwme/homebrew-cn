class Anubis < Formula
  desc "Protect resources from scraper bots"
  homepage "https:anubis.techaro.lol"
  url "https:github.comTecharoHQanubisarchiverefstagsv1.18.0.tar.gz"
  sha256 "b543f3c4af32a71994f4290b901b5670ce3cc7756b9db2c86d2569286d6dd6ef"
  license "MIT"
  head "https:github.comTecharoHQanubis.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b162bd9c43dedbe24fbfff3667d5df2cf433d34c698b286a894ff2dbba8ee9ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7387ba7dd8e716f47bc486ca499dc40a02484ed5284186c591032f61c2f5241e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "774a900e165f381bbebc6dcbb55cdde962cad597968a9c1912f20e1c0418b28e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2328432dc08c377c0f4ef8641e3806856785c2bfb7e26d388abd0e53daadfa9e"
    sha256 cellar: :any_skip_relocation, ventura:       "2608708e94511311a6b6f5e363bc98aaadc9c11358c1a05231161acc871f1384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655f3a50f4db66e85fa0a866d146de7cc0bd2165b9692513b3314aec5185c414"
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
      "-serve-robots-txt", "-use-remote-address", "127.0.0.1"

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