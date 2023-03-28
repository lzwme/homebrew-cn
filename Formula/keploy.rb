require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://ghproxy.com/https://github.com/keploy/keploy/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "2c50760ed5c9ba56d3baca066bee0ef0e6995274d5c83a602f4e9a9876a8cf77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ed4a08557b476427434fc73f354482a893a5352d55e0e9df1f950c7a617e873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b6e2750ac4fa6f1546c7dde8c1dfee5b027cf72592a4d14ba22efcf90130cd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9dcbda59adb83bc9c3c333a17a553c43498362a5bf6138c351d8d6cd376dcdf"
    sha256 cellar: :any_skip_relocation, ventura:        "762e42cb21812c79badfe37cd3038868c3520f19c399f392d51005480be0dde7"
    sha256 cellar: :any_skip_relocation, monterey:       "21f8027f13f4574361d291dd244b4662592cdde8f6df851c4cda6a36e8769ed1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0949be39bd3e2093f21cb9737a60adc2e3d203a1e2a54adc4e47b5ea72a6588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55092b4cc04371e396acf291e57051592d1cd60adb2ee015e7cccf7e6aec2b0"
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