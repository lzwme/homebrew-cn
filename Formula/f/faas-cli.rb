class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://ghfast.top/https://github.com/openfaas/faas-cli/archive/refs/tags/0.18.1.tar.gz"
  sha256 "c924077335f6a8cdf4f9c3215854ac18cfea31169f9c19639a4093210e31658a"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91bf38e1ac1ec3c98dd7ecdfa2276fde9f8f61aedf0a91bdd23c1204e5f900d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91bf38e1ac1ec3c98dd7ecdfa2276fde9f8f61aedf0a91bdd23c1204e5f900d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91bf38e1ac1ec3c98dd7ecdfa2276fde9f8f61aedf0a91bdd23c1204e5f900d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6712d94f87cadbceb247cd838cab9dec5661e6bfd6839ab9cd6f867a09c70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a5fce17d374da4f4151097173f12a174eedabbd9fee3101421657df6c4abaf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc423ee364491d2f28bde988bd492a47c7d68ea6a5f65d0c63f0bce5eb598d10"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    project = "github.com/openfaas/faas-cli"
    ldflags = %W[
      -s -w
      -X #{project}/version.GitCommit=
      -X #{project}/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "-a", "-installsuffix", "cgo"
    bin.install_symlink "faas-cli" => "faas"

    generate_completions_from_executable(bin/"faas-cli", "completion", "--shell", shells: [:bash, :zsh])
    # make zsh completions also work for `faas` symlink
    inreplace zsh_completion/"_faas-cli", "#compdef faas-cli", "#compdef faas-cli\ncompdef faas=faas-cli"
  end

  test do
    require "socket"

    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
    pid = fork do
      loop do
        socket = server.accept
        response = "OK"
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    (testpath/"test.yml").write <<~YAML
      provider:
        name: openfaas
        gateway: https://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    YAML

    begin
      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "dockerfile", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node20", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml", 1)
      assert_match "Deploying: dummy_function.", output

      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end