class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://ghfast.top/https://github.com/openfaas/faas-cli/archive/refs/tags/0.17.7.tar.gz"
  sha256 "10b2831f963e44347261f9f6e85e0001fdaa2ad43c8746011caacda6ece66494"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d62ba91b63afebaa88f570863d7c1ea36f12e5b0d97f5c4433c717f9b8af77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d62ba91b63afebaa88f570863d7c1ea36f12e5b0d97f5c4433c717f9b8af77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d62ba91b63afebaa88f570863d7c1ea36f12e5b0d97f5c4433c717f9b8af77"
    sha256 cellar: :any_skip_relocation, sonoma:        "909f911995ec691eb1f27c92a3d416c2f1835089d4d6e406f3118a5e1634f07c"
    sha256 cellar: :any_skip_relocation, ventura:       "909f911995ec691eb1f27c92a3d416c2f1835089d4d6e406f3118a5e1634f07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4a89c619fd5beb6e5494d78cbf9464cf64a7f2956eed67e605b67c437cac67"
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