class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/mistydemeo/launch_socket_server"
  url "https://ghfast.top/https://github.com/mistydemeo/launch_socket_server/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "507184544d170dab63e6112198212033aaa84edf0e092c1dfe641087f092f365"
  license "MIT"
  head "https://github.com/mistydemeo/launch_socket_server.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4dc5f49b22d19b1a6d79d1697b52883dfb9ef8f39d2777a49c6aed182b9ef0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ce6af2c7124bc91494a306292073b296f109482869a4c01870ef97e81d5d62d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f097f91e97343b78e0208793705506ccec3ea9deddb38d9a15d11c11103888cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "055953e5098f4c8e2c823d58e123eb3a905174c9619791b3fa54de1d671b193d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b95b2bbe04b54feb6b103b5ead74f984160ff920a8914619004b40c1402bceb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fd45ecadc044db17343dcbd89327fd2324512e7055f9b30e26f40dc4c513bc2"
    sha256 cellar: :any_skip_relocation, ventura:        "1201c5615810d1e37d6c6c2c26ccadf8ffd9a346905cbf064ea637aab8f04629"
    sha256 cellar: :any_skip_relocation, monterey:       "165fd5a279db8b88e586ca82f2c1017946a7675c8f0c158921d9cb48d152e13b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d490a674d736272ea67f2289d5eb715b5aa48acf5e289a6a8e8327cd4cbc4a4"
    sha256 cellar: :any_skip_relocation, catalina:       "ff86499103ad1d9d33cdc039e24f065aa08405bda980c9e242c46ed157bc33ff"
    sha256 cellar: :any_skip_relocation, mojave:         "823d84eddeb72fdabeccdc189bc19269485bfeb23d0a57824cdbf95c92a6ccb8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ef58f2afc33d6454282d1e1b92e4d16269885464707ae58079c29514f4cadc60"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run [opt_sbin/"launch_socket_server", "-"]
    environment_variables LAUNCH_PROGRAM_TCP_ADDRESS: "127.0.0.1:8080"
    keep_alive true
    require_root true
    error_log_path var/"log/launch_socket_server.log"
    log_path var/"log/launch_socket_server.log"
    sockets "tcp://0.0.0.0:80"
  end

  test do
    assert_includes shell_output("#{opt_sbin}/launch_socket_server 2>&1; true"),
      "usage: #{opt_sbin}/launch_socket_server"
  end
end