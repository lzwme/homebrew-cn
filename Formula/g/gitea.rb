class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.23.4gitea-src-1.23.4.tar.gz"
  sha256 "01125e1ac8017b2cbfd53784218a70e5200cf61328e311b5e2c2942c36ac5b8d"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92bf4ffed5f33997eb5efe6c180ce9b5ef72831557857cd0e9f301d8dcba1a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a79fe6dac2785838e55ac959563cbd822d8643d33c5ebac3a80b6cbd8cc1270"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5450e95363107531789cb426bfdf13d6a48c78147f65d98b54d7bd2991c6b9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "d34e35c28878c9c2f2f45292a31a6acbcacdc6e4fe0604328788d30f3948fb60"
    sha256 cellar: :any_skip_relocation, ventura:       "ba2f39ca63ab107bdf5f6d14a8931ea71842be8e1d41710ba33017c3b9c87f81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038ab73ae8bde0844764ed1f9fac920cd195cfafe24041b12a58fa45adcf124f"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
  end

  service do
    run [opt_bin"gitea", "web", "--work-path", var"gitea"]
    keep_alive true
    log_path var"loggitea.log"
    error_log_path var"loggitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin"gitea", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s http:localhost:#{port}apisettingsapi")
    assert_match "Go to default page", output

    output = shell_output("curl -s http:localhost:#{port}")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end