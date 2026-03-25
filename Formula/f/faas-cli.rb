class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://ghfast.top/https://github.com/openfaas/faas-cli/archive/refs/tags/0.18.7.tar.gz"
  sha256 "d38e43c87191762330d17346d62186344001bb016ef47caef2c4a0adff583ef1"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c946315387ba21adb10f3c149dfbe3841e2e6b0c1d4312afdb2b722049844e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c946315387ba21adb10f3c149dfbe3841e2e6b0c1d4312afdb2b722049844e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c946315387ba21adb10f3c149dfbe3841e2e6b0c1d4312afdb2b722049844e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e85b2c243c6212701181bdf527f05da01882cb910bc4ec8ea3ae17c4dee3651f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98730114a0783f794e25970cde4ed3760aba6d6afa8d4e3bf61f25b2bb1ca7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b03105927bd52411489acbf5494e491015cf3ec4f8dfff6a1cef9c313d921ede"
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