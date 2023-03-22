require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://ghproxy.com/https://github.com/keploy/keploy/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "e45ccc8718d573983712bd1c286849dd97517129883cd2ba0472efcc59d0277b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52f25ba189cd416b2d400fa786c8db5c231fed29be8847002c39f899e9fda151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65639e655ccebe87876afa853e56783bbed9679d63207443b860921a80aa52b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98a1e37e72a35c27175a72391bb3370b10fcc06de249bcc2db9e5c0fad521ce4"
    sha256 cellar: :any_skip_relocation, ventura:        "24efc3c6716572886eaea92557447ce2041c6474390cdf33ea8f79d718e29a05"
    sha256 cellar: :any_skip_relocation, monterey:       "159c5b690f942fd3885bd46551cc4cc19bc327e0ca7887d10c32dd13def57f5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9f89fc82d7e67f118450d0f645f96ec8756913956e0ab4a381fce26ff061972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7adb2d849d3c1ef0c0dc5034876ce023b71f723cc6db29158e7f323f8d975ff4"
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