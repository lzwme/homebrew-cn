class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:roadrunner.dev"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2023.3.9.tar.gz"
  sha256 "59d7daee2fa20c6d167c458d2cbe9ece88b8a45d2a2af4da53c4dc74ff4f9d58"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "697a6c3643c1321db7cd883083fededef1c8d5049826ef4d3a69280648c8043a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5fd9b34ee0ec94e968514b67237e5f3db86df4e8e7a9d8e044a8ece9c476bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0445898210ce0ac076e9d951620c3cabeb41b51a54c84c504916dbf72a543593"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd901ae08b783311289ee33985bb4cc04d47a90c79301f0234ec1b9c3e9ab7bf"
    sha256 cellar: :any_skip_relocation, ventura:        "a1aa162df5a8bfa75d15ee02c9ed96b2440b3b7b34239d84df1b0c21415216f1"
    sha256 cellar: :any_skip_relocation, monterey:       "7da3b064d07d0786674af25884910c80910f5e83371d83bf90e749d2915fd4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caabe58aa6ae9ac0f3ba3d0700f4bf0ad7137ea3eb0162499db18adeed802fd0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comroadrunner-serverroadrunnerv2023internalmeta.version=#{version}
      -X github.comroadrunner-serverroadrunnerv2023internalmeta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(output: bin"rr", ldflags: ldflags), ".cmdrr"

    generate_completions_from_executable(bin"rr", "completion")
  end

  test do
    port = free_port
    (testpath".rr.yaml").write <<~EOS
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp:127.0.0.1:#{port}
    EOS

    output = shell_output("#{bin}rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}rr --version")
  end
end