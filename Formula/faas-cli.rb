class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.11",
      revision: "a9270859f135a19eecf1f95920eb6e74ffa208c9"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1110757b3fc4cfcc1cfc5f53d1b50965b37d29046dc977e2d04e5fb9fcd85ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1110757b3fc4cfcc1cfc5f53d1b50965b37d29046dc977e2d04e5fb9fcd85ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1110757b3fc4cfcc1cfc5f53d1b50965b37d29046dc977e2d04e5fb9fcd85ec"
    sha256 cellar: :any_skip_relocation, ventura:        "bf28e28cffcb050f7bb01d5eb6a79b318ba0251b60a0c02f3eeb21ced39cbd02"
    sha256 cellar: :any_skip_relocation, monterey:       "bf28e28cffcb050f7bb01d5eb6a79b318ba0251b60a0c02f3eeb21ced39cbd02"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf28e28cffcb050f7bb01d5eb6a79b318ba0251b60a0c02f3eeb21ced39cbd02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8260488f8970cafa8ce2da48e5ee10a4372a2320aee3a575a03c07256b68459b"
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