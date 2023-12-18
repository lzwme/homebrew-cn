class FaasCli < Formula
  desc "CLI for templating andor deploying FaaS functions"
  homepage "https:www.openfaas.com"
  url "https:github.comopenfaasfaas-cli.git",
      tag:      "0.16.21",
      revision: "31db71d7914d982bdd927aa44cf2e4c4b85189ac"
  license "MIT"
  head "https:github.comopenfaasfaas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9984e8aa9791033206698e33f4ce65114ee403539ecdb00b9111b8452bed2522"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a90c6f50e147fbbc04e3e009296846b6186305d56a4f3763c2b80e33951096b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3009104803c0b3f7b267f3b3dac13279bac45d28509d51630b4cfc4667b7bb34"
    sha256 cellar: :any_skip_relocation, sonoma:         "c26f41f1db66c467e36738cf134b7ae9bb7e48e8b494f3459f36bd57aa7b9dd3"
    sha256 cellar: :any_skip_relocation, ventura:        "ef20ee63a028b7ee521faddc116277c3533d628b14f4a46d62a363123f0925d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c006d636e291cb01940cb04f36e0ea189065cf40d7bd71fe6d5a49343b4fed13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7ff420ef92e362ca72008457e8c2579af221e4267a02ecc85c9b21c4cb0642"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    project = "github.comopenfaasfaas-cli"
    ldflags = %W[
      -s -w
      -X #{project}version.GitCommit=#{Utils.git_head}
      -X #{project}version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-a", "-installsuffix", "cgo"
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

      commit_regex = [a-f0-9]{40}
      faas_cli_version = shell_output("#{bin}faas-cli version")
      assert_match commit_regex, faas_cli_version
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end