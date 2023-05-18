class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.4",
      revision: "2ca3f90e0ed0806c0f12bda0cc5df0a5706c193a"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a54ac7015b51e64e9103f33803d484bae8b26ef63a1e4fb7f594374cc824f38f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54ac7015b51e64e9103f33803d484bae8b26ef63a1e4fb7f594374cc824f38f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a54ac7015b51e64e9103f33803d484bae8b26ef63a1e4fb7f594374cc824f38f"
    sha256 cellar: :any_skip_relocation, ventura:        "a272f583b3cd4e06988db1ee7b710b4d423d5be0cd3d3afd9289cf6b6fde2ea1"
    sha256 cellar: :any_skip_relocation, monterey:       "a272f583b3cd4e06988db1ee7b710b4d423d5be0cd3d3afd9289cf6b6fde2ea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a272f583b3cd4e06988db1ee7b710b4d423d5be0cd3d3afd9289cf6b6fde2ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93b631010853fa11478a43e6fb8af6f8afb7e257ee9b4f3d15342764246141c"
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