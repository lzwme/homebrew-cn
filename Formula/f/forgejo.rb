class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v12.0.1/forgejo-src-12.0.1.tar.gz"
  sha256 "792f0435e9e4620da96a92305ed752f54b47ebc23d5f8e08a70299bac2245dd9"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "247df72c125144050d897bddd0730e5c4be4f3e9f42fb750671bb9f967b82c69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ea31cfae57a04706551b2c93971c1ee1d943f8fb06a227c24e36d032455b006"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f929960fe69d51328658bed7a3d483ca6e63b588903c4dfa839fd63d51ba7c88"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef251e31ba34b75207c8cf64e0b463eb0c7fb367e27d3cea9666f08834e66ec2"
    sha256 cellar: :any_skip_relocation, ventura:       "08f1141686d352ae9440abddd70c28cb65da35c127c2138518d2c041c1eaf66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "059e06ff01da10063584fd5a0be92d1f73847fcc1444d894f696d067d64a9ce0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea" => "forgejo"
  end

  service do
    run [opt_bin/"forgejo", "web", "--work-path", var/"forgejo"]
    keep_alive true
    log_path var/"log/forgejo.log"
    error_log_path var/"log/forgejo.log"
  end

  test do
    ENV["FORGEJO_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end