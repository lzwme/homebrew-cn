class FaasCli < Formula
  desc "CLI for templating andor deploying FaaS functions"
  homepage "https:www.openfaas.com"
  url "https:github.comopenfaasfaas-cli.git",
      tag:      "0.16.22",
      revision: "8383725bfc45d4a40e3fdfc97d5d77f4a6e5791b"
  license "MIT"
  head "https:github.comopenfaasfaas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab81323aa504157eb48c89efd2bbc1e736f2cd12015695456755eaa74850d411"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84ea76e2a5886ba66412e83125e8b52d14a7c50c1be5a44f89eb5260a03f0c1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33ec2f5b6f3055398a924d1576d57c29ce2b183925685a090b1b6664919ad159"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f54274e25b3716f45a2b453f8daf42ea61eda7df8ba4748865757bdab9fb650"
    sha256 cellar: :any_skip_relocation, ventura:        "5840da62dcd9b63f49f96891e3a9d28b96e15e3cfb660b042f883d53a4e217ae"
    sha256 cellar: :any_skip_relocation, monterey:       "c8e390a35c2ded5b0c0b57543da98d2b0871ffbc23e7581a1d416cb344361878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f3eb1f97baa83581e7fdde30a9e9dfd2e42765a6335c25c6976436f2e917d5"
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