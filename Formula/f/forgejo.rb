class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v15.0.4/forgejo-src-15.0.4.tar.gz"
  sha256 "2edac43d70380587dde35d8d8a80fe5791909b9d79d1a564a4d1056bc5261dda"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b64a176d1ffff188fd3c45cfa2e3eaf2277d9614e6351e4124bf736abc9224b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f67e9cfc1f1bcffc89877138cc57dd69dee2147dd9af66197d0ee48a553457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a79b421e75532336f3febfc1e32dde34632742a11cca90f5e883626111abe79a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2784cbe572f282eb1dcc379cf52026fc3469dd9c7da0998c280a8a46e29db19d"
    sha256 cellar: :any,                 arm64_linux:   "1d6b47061935b438432933ed02d553933e92d1f54dfd844ae1e0f86ec2313504"
    sha256 cellar: :any,                 x86_64_linux:  "118bb7499012f4375dd6522064ec1a5335326adc7fb2ec7e3933ecb9607abbe3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
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

    pid = spawn bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl --silent http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end