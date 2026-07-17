class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.6.0",
      revision: "03e3a243b6f07d17c60ce0a182adee7cf4c424eb"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5015828c088be74bb5cec6f01eccd021b43fe428143cd70ebd2991e7a98bda92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59bbc4355955f80b8bcfbd42c9e3bbb19d62f76ba0f2c61835cf1773efb8f7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4063d3f58096d46fea7391b8d27ce7c0f8e988e62d44b17903092861cc7f3236"
    sha256 cellar: :any_skip_relocation, sonoma:        "a684e52f2beea84d3aec07705d3d02866f102aeb361b0f7244dfac1619dc9e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "744013ab41538bb2fc10750f803061800e52a23dad6fdf9ef5653258fe65b14b"
    sha256 cellar: :any,                 x86_64_linux:  "d3b6ca31095a385607543e1914d6421fe96ddc7175348edba10a9f4153982e2b"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "pnpm" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    # Build ui assets
    cd "ui" do
      ENV.prepend_path "PATH", formula_opt_libexec("node@22")/"bin" # for pnpm
      # Prevent pnpm from downloading another copy due to `packageManager` field
      (buildpath/"ui/pnpm-workspace.yaml").append_lines "managePackageManagerVersions: false"
      system "pnpm", "install", "--frozen-lockfile"
      system "pnpm", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/openbao/openbao/version.fullVersion=#{version}
      -X github.com/openbao/openbao/version.GitCommit=#{Utils.git_head}
      -X github.com/openbao/openbao/version.BuildDate=#{time.iso8601}
    ]
    tags = %w[testonly ui]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"bao")
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"

    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end