require "language/node"

class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://ghproxy.com/https://github.com/keploy/keploy/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "9ade55cfc332ef5fc65e7d89e372c9fe88df95cf978895be9b519c3f4d5e7c76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b36be0638618114244a0e446ee45c2eab26d6e7bf16b9056a62e9ae9015ffda5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04f25f600e5f5b1d44c31f161ed1a0625a985a67e338d156cd81a82d45b49442"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e774ce7b96505bc7e67b21eeb958487d0e3da71531dfbae6c91e58bd4e43a85e"
    sha256 cellar: :any_skip_relocation, ventura:        "11ddeaa7e734da82c73efe6ce7306232b52bb7f839d9e94a6b88ceb1c274a3aa"
    sha256 cellar: :any_skip_relocation, monterey:       "6c6c1e338bd508509d37996232e4b4e7882260cbfc1335128bfa0c1be1c9485b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5b9f6b64139d90fdbd1c85cbb57f30430419920126306f27aab54a6fdad217a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d128a2fafd7e9e3488920074fe638dab684e81f7deb607e4ac068b2bdbf22f2a"
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