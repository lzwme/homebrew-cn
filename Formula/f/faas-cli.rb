class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://ghfast.top/https://github.com/openfaas/faas-cli/archive/refs/tags/0.18.16.tar.gz"
  sha256 "e79a1dcc08657fa40241b4a5ce7adfd39e4b0dad9f62d21bdf82d04f0cee962e"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ae43cef25afe0f3dfe5d96d21260d7eb4bb78b6892fe975d0716cc39246159b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ae43cef25afe0f3dfe5d96d21260d7eb4bb78b6892fe975d0716cc39246159b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ae43cef25afe0f3dfe5d96d21260d7eb4bb78b6892fe975d0716cc39246159b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef316625e043bee08fbcbc8ea373125c1de421b4f2bd970bc03a880e256bb277"
    sha256 cellar: :any,                 x86_64_linux:      "a4c1f8dce13edf4924489c3cb511ac2b70af8b993e55375285658a05826e4f16"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    project = "github.com/openfaas/faas-cli"
    ldflags = %W[
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
      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify --yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "dockerfile", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node20", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify --yaml test.yml", 1)
      assert_match "Deploying: dummy_function.", output

      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end