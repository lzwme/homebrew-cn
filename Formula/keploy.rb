require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://ghproxy.com/https://github.com/keploy/keploy/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a80508f29d26b9d59130d53b7715731fc081d1796b12cd4bb2798961857d2c04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d261da38e1424ad9ca8226546f1b2629b98be72e324588a31150c04b7936b54f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed408b569abe25e7a1ad974d293cc293245732479066853d89c801b5e21c35f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "415537bdcc9a76e125dd0cc776e08f6f1d5ee63cb29ea7837deba1f0e404e009"
    sha256 cellar: :any_skip_relocation, ventura:        "6e311728d8fad686fac0f202e8aada24fcd76bf8f91376eb2efba2f3ef9d1245"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ce65273983c26ee6f809bf56dbed0f523007c8459370bd59d7761a36007c27"
    sha256 cellar: :any_skip_relocation, big_sur:        "46993c305a3fac5c87eadb8485c674ac9236d41ae01ebe769379a67dd7a1526b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1212bc10e2906ee220d6f0361636268dd22efc5bfe8109fcec92d00e7fadd83a"
  end

  depends_on "gatsby-cli" => :build
  depends_on "go" => :build
  depends_on "node"

  resource("ui") do
    url "https://ghproxy.com/https://github.com/keploy/ui/archive/refs/tags/0.1.0.tar.gz"
    sha256 "d12cdad7fa1c77b8bd755030e9479007e9fcb476fecd0fa6938f076f6633028e"
  end

  def install
    resource("ui").stage do
      ENV["SHARP_IGNORE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "install", "--legacy-peer-deps", *Language::Node.local_npm_install_args
      system "gatsby", "build"
      buildpath.install "./public"
    end
    cp_r "public", "web", remove_destination: true
    system "go", "build", *std_go_args, "./cmd/server"
  end

  test do
    require "pty"

    port = free_port
    env = { "PORT" => port.to_s }
    executable = bin/"keploy"

    output = ""
    PTY.spawn(env, executable) do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("keploy started at port #{port}", output)
  end
end