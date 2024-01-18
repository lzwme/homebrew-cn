class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https:about.gitea.com"
  url "https:dl.gitea.comgitea1.21.4gitea-src-1.21.4.tar.gz"
  sha256 "6e4448da6eda1eb407e7041b9b8328ca0ac5e5d6bb8f88bc41dfdaa0c25b852d"
  license "MIT"
  head "https:github.comgo-giteagitea.git", branch: "main"

  livecheck do
    url "https:dl.gitea.comgiteaversion.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2300ae75dc631ec61f8e7fca7e5f5f49fb85de1a0fc64e967c1b2c9d48e390f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89366b8fea9ded63e95d12c66af7ad00674cddd44c08ee3a7b55a67ba8a0fcd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a75d434ade13c158f51bbcfaf38e504f77e6943a1026fe6eea957029f4336f21"
    sha256 cellar: :any_skip_relocation, sonoma:         "6953436d0efacd69488a3aa4de7ae11510e097c400457b76700bd14133a6a1da"
    sha256 cellar: :any_skip_relocation, ventura:        "13aa009dcaa367efe65b92127eee96052e38779e228dda99a936c3044590c5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "13b805561322e5a4461851fe8d173dff07eeeccadf78fb8942b9ad5dd240d94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8277dd6ffa1d35fbf595f061f7090025c81b1bdfa55a8c001b15dc5698826487"
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
    run [opt_bin"gitea", "web"]
    keep_alive true
    working_dir opt_libexec
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