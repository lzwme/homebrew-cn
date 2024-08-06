class FaasCli < Formula
  desc "CLI for templating andor deploying FaaS functions"
  homepage "https:www.openfaas.com"
  url "https:github.comopenfaasfaas-cliarchiverefstags0.16.32.tar.gz"
  sha256 "69fd10fc5cb28e23faad41a08de4460c42cfa1e39fddf889bc9221004a4e2cda"
  license "MIT"
  head "https:github.comopenfaasfaas-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4044b122d40112ab310f66f5e49fbb63d832998f0338868810b592c3a4caa5f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bab9134418cac8a1050742fee50d8399a814d98a5e5455b1240ebfa90d71eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd3e973a0d9fb0de3d218b3eac0acf2ba4af3c28b708ac7f76bb87c6c0af4c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "68f2b3c357afe5d063677471720c4d553d1e338ca71d461e27fe500e48edee47"
    sha256 cellar: :any_skip_relocation, ventura:        "b0eed3adb5ad8e7599614418ae1cf3f5f66b1e3d171541f18f0d8da610fc9225"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8f6ca2dbe5159ca35205821f80f06fedfb10834e4bb4d350ff85059f5cd1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c460e0054ff5a2eeeaa886d4fc7d5d4803cff0e89d5dbe3554a250947333c47"
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