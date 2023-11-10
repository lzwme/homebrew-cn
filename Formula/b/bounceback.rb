class Bounceback < Formula
  desc "Stealth redirector for red team operation security"
  homepage "https://github.com/D00Movenok/BounceBack"
  url "https://ghproxy.com/https://github.com/D00Movenok/BounceBack/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "9f18c3b00f19f832a6ec9cfc4383d38a3ca400e470cc356c3cd41ea3d7919466"
  license "MIT"
  head "https://github.com/D00Movenok/BounceBack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d1a1cb9b0e1e045148ee7e5da294ba39c325a1a3e760582be24720f93f09a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11aa1e5138d725acfaa27114628d3d0fbdd73d6e8df72c33af5011dc0d8da678"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273da70d28a7a4e1949a1e0c6f885aee186ea02cae50fd94ea78ad8b21600d1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9046acab556de00866e498684928a05d88da79ffa9996141189a03fe2e6b4741"
    sha256 cellar: :any_skip_relocation, ventura:        "be1595182d66d63febe72186b936c91db3835547f160ef3cf733039de7bc0cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5a2e6f0539590f044276e03c22f9a638192b8583c450d587f3e59e76e52306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cb99159e2eccd44ed7c0721e5779691cd5cbe18b6fb5a71cb6e032f61c4d08e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/bounceback"

    pkgshare.install "data"
    # update relative data path to homebrew pkg path
    inreplace "config.yml" do |s|
      s.gsub! " data", " #{pkgshare}/data"
    end
    etc.install "config.yml" => "bounceback.yml"
  end

  service do
    run [opt_bin/"bounceback", "--config", etc/"bounceback.yml"]
    keep_alive true
    working_dir var
    log_path var/"log/bounceback.log"
    error_log_path var/"log/bounceback.log"
  end

  test do
    fork do
      exec bin/"bounceback", "--config", etc/"bounceback.yml"
    end
    sleep 2
    assert_match "\"message\":\"Starting proxies\"", (testpath/"bounceback.log").read
    assert_match version.to_s, shell_output("#{bin}/bounceback --help", 2)
  end
end