class FaasCli < Formula
  desc "CLI for templating andor deploying FaaS functions"
  homepage "https:www.openfaas.com"
  url "https:github.comopenfaasfaas-cliarchiverefstags0.16.30.tar.gz"
  sha256 "7cf8aba4b73f3b76fe345203d1f5c2042b40ec8a28cb34c28a2edc5c5105e426"
  license "MIT"
  head "https:github.comopenfaasfaas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6104c8fe5ec0e0bf9634b51093a1ceea4b8649c4fafe9e447b8b1dc499060e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e3e763c5f7667509aa136994ec060d34c75e4b2b583f2d65bd6c94445cd2d4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb16944f53999439c3e2b5d55397041d20808cfbc5871d6006c77b148d94ec7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "544b78e1ed26a199281d62f304a77d2479d38ea84706249c2429637b88807058"
    sha256 cellar: :any_skip_relocation, ventura:        "7e3ffbd26696fda66d41d4cd6888e9993cab8f3ad2fc32946e6d8af133d7bbfe"
    sha256 cellar: :any_skip_relocation, monterey:       "67b1a2b44ca2623639a9c72bda8cae19e0a1315c4a4077706dd399c34ba8a711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7067144278169f6da5db754659ebe059cdb9a344e153a04e48a329481fb2a073"
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

    (testpath"test.yml").write <<~EOS
      provider:
        name: openfaas
        gateway: https:localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: .dummy_function
          image: dummy_image
    EOS

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