class FaasCli < Formula
  desc "CLI for templating andor deploying FaaS functions"
  homepage "https:www.openfaas.com"
  url "https:github.comopenfaasfaas-cli.git",
      tag:      "0.16.25",
      revision: "d0bffb13a2a068d5b89333e41125b795b3a0de1a"
  license "MIT"
  head "https:github.comopenfaasfaas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b4e0f2aee88ef6a473f7fa0a2a3bba9d406ef0f3669e843ee3b454df0410891"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "969cc2168f81294cf7ff6d64e7334fd1cf415618c24ad6132968fbc3c2bdf4cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71dae86d1563ac20687f171d83767be22f8ab3326dd91f8cd8f2d3b7860e7a5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "92ff33ccab58356f9f9cc0cd8c0166cf351fdae08cf2e903a1fdd08b970d863a"
    sha256 cellar: :any_skip_relocation, ventura:        "86ca9b743840d2e40fadca7ddcea6fab5070e06a8b9ae0e75d5b0a0b05e9ce7c"
    sha256 cellar: :any_skip_relocation, monterey:       "089b5342efa907ba841c12c250a633c736dc7fb02bb043e1be8012e8c76a422b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75ef266243dbf488724379e038f6e44c42e559f63cc390e32a044e73eb8145f0"
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