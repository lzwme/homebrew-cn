class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://ghfast.top/https://github.com/openfaas/faas-cli/archive/refs/tags/0.18.4.tar.gz"
  sha256 "f4c80bfd79a6c0acd8f81156412dc7080158fea06a7121ebc97b01a9311bc972"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252089773391587d463f4535b66a9e2bf5f4aef4a29248bf2e981271ddf22a39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252089773391587d463f4535b66a9e2bf5f4aef4a29248bf2e981271ddf22a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "252089773391587d463f4535b66a9e2bf5f4aef4a29248bf2e981271ddf22a39"
    sha256 cellar: :any_skip_relocation, sonoma:        "e23a8d56085edebaad4b322e9155070bd5c93904588d6ff1915445cd01a5fc45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbf6d7972cfc244f56ec5f6060c5969933b54a43d337e5692c0d2fbe3357ad33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebeb2927ff946f989880b6cb4531d2cc014d75737301594f3a9e7d86c12ac1dd"
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