class FaasCli < Formula
  desc "CLI for templating andor deploying FaaS functions"
  homepage "https:www.openfaas.com"
  url "https:github.comopenfaasfaas-cliarchiverefstags0.16.31.tar.gz"
  sha256 "322520eb0c94cbe513a140ca362550ccdef42639ace4bf8e4d2a505b1fb4d905"
  license "MIT"
  head "https:github.comopenfaasfaas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9af9e433a1c198da376ffdb9a34761162df551a338b84668657bd99f4756cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e98d1f84a483912f89b650acfcabf974b8282ed017d03594c91e428c239ccd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0221f7a772110a86d4b993be630cd0cf1047f80943151721cdb8f8c008c502ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "76654611c241aa3ebfc49d38a021b7fbb4cae807b600648a5b644768fa05cc2a"
    sha256 cellar: :any_skip_relocation, ventura:        "5b2e617a5d14c19d8fa39f11f1e1c8b15f53a7262f1fc5d27ee0fd94a6fa6a60"
    sha256 cellar: :any_skip_relocation, monterey:       "e8e80beaa832d57754134a6906d453c9e620bdd7d957b93345fe691251cf606c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc75707af24c4086c7fb9e27b81d843472369de6cb215224a65c30e3822ee7b"
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