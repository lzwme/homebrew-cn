class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.10",
      revision: "d240045769678f0fa998e9311d4a81a89f0953d2"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92c8cfcd9c5a70a583fc77988a448a555c40535693a08923631deb34f7e29c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b92c8cfcd9c5a70a583fc77988a448a555c40535693a08923631deb34f7e29c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b92c8cfcd9c5a70a583fc77988a448a555c40535693a08923631deb34f7e29c4"
    sha256 cellar: :any_skip_relocation, ventura:        "d06a33a3d5fab1138e9114c9acab02b059f0de743bce0a0104d7f672b9b20ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "d06a33a3d5fab1138e9114c9acab02b059f0de743bce0a0104d7f672b9b20ca2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d06a33a3d5fab1138e9114c9acab02b059f0de743bce0a0104d7f672b9b20ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e0c73a8b7cdd075fb930d1018a7f5824730e2d37ade89cb63b66fccb33e843"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    project = "github.com/openfaas/faas-cli"
    ldflags = %W[
      -s -w
      -X #{project}/version.GitCommit=#{Utils.git_head}
      -X #{project}/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-a", "-installsuffix", "cgo"
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

    (testpath/"test.yml").write <<~EOS
      provider:
        name: openfaas
        gateway: https://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOS

    begin
      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "ruby", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml", 1)
      assert_match "Deploying: dummy_function.", output

      commit_regex = /[a-f0-9]{40}/
      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match commit_regex, faas_cli_version
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end