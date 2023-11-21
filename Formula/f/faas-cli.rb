class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://www.openfaas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      tag:      "0.16.18",
      revision: "9981e9ea7065d5dc2d4a17013aca04a1c97fe4df"
  license "MIT"
  head "https://github.com/openfaas/faas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddea51fef4c670fc9e60f82d17b96713e745cb8c49caa1f8aec01862da3785da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "006f47edde460134159ff16f963a7807a271c290479c6ec319ef44982e9c3f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47c2cf070c01154efebca6e60784f1b7b013192c763722ebcc0f5938368ad3a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c5d45d9261c7ac9dcc9065edb1793192a6357e93faa0d2a2d34bfde64b04e23"
    sha256 cellar: :any_skip_relocation, ventura:        "cafbc12d785cf26ebe34d90284d633db34e9abc83f69829ab3ea535c32278c73"
    sha256 cellar: :any_skip_relocation, monterey:       "d2137b5832d2d453cf6df0e3ed3a79204315aae1f95733ffa11a7cc6d15f2127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8161dc61fb92530bebee984bd30f4d4de63d4cdc0253de4e73cbf8d88798a38"
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = OS.kernel_name.downcase
    ENV["XC_ARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    project = "github.com/openfaas/faas-cli"
    ldflags = %W[
      -s -w
      -X #{project}/version.GitCommit=#{Utils.git_head}
      -X #{project}/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-a", "-installsuffix", "cgo"
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

    (testpath/"test.yml").write <<~EOS
      provider:
        name: openfaas
        gateway: https://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOS

    begin
      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "ruby", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy --tls-no-verify -yaml test.yml", 1)
      assert_match "Deploying: dummy_function.", output

      commit_regex = /[a-f0-9]{40}/
      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match commit_regex, faas_cli_version
      assert_match version.to_s, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end