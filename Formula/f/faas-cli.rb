class FaasCli < Formula
  desc "CLI for templating andor deploying FaaS functions"
  homepage "https:www.openfaas.com"
  url "https:github.comopenfaasfaas-cliarchiverefstags0.16.38.tar.gz"
  sha256 "76b6990376aa510d993f8fc973f55d5bfbd9171689edc0a7fd92b8dfe3579ea3"
  license "MIT"
  head "https:github.comopenfaasfaas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ce1a3182adc50dc7421fc6d7e2de1871e5dc07d6ac130129c2559f58ab37031"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ce1a3182adc50dc7421fc6d7e2de1871e5dc07d6ac130129c2559f58ab37031"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ce1a3182adc50dc7421fc6d7e2de1871e5dc07d6ac130129c2559f58ab37031"
    sha256 cellar: :any_skip_relocation, sonoma:        "739fcdfa935332937dfd059b05d299e9221cd7aeb6db4d17f4cf070c66b778dd"
    sha256 cellar: :any_skip_relocation, ventura:       "739fcdfa935332937dfd059b05d299e9221cd7aeb6db4d17f4cf070c66b778dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d726431bdb132eaff35659e4bf1a298745933a90a22a8aa58d428c2c7381bae3"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    project = "github.comopenfaasfaas-cli"
    ldflags = %W[
      -s -w
      -X #{project}version.GitCommit=
      -X #{project}version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "-a", "-installsuffix", "cgo"
    bin.install_symlink "faas-cli" => "faas"

    generate_completions_from_executable(bin"faas-cli", "completion", "--shell", shells: [:bash, :zsh])
    # make zsh completions also work for `faas` symlink
    inreplace zsh_completion"_faas-cli", "#compdef faas-cli", "#compdef faas-cli\ncompdef faas=faas-cli"
  end

  test do
    require "socket"

    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
    pid = fork do
      loop do
        socket = server.accept
        response = "OK"
        socket.print "HTTP1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    (testpath"test.yml").write <<~YAML
      provider:
        name: openfaas
        gateway: https:localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: .dummy_function
          image: dummy_image
    YAML

    begin
      output = shell_output("#{bin}faas-cli deploy --tls-no-verify -yaml test.yml 2>&1", 1)
      assert_match "stat .templatepythontemplate.yml", output

      assert_match "ruby", shell_output("#{bin}faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}faas-cli new --list")

      output = shell_output("#{bin}faas-cli deploy --tls-no-verify -yaml test.yml", 1)
      assert_match "Deploying: dummy_function.", output

      faas_cli_version = shell_output("#{bin}faas-cli version")
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end