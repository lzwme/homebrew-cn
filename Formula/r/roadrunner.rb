class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https:roadrunner.dev"
  url "https:github.comroadrunner-serverroadrunnerarchiverefstagsv2024.3.0.tar.gz"
  sha256 "f60af569fb262cafe2a9ca4f04ebf6b956a387a689b70f920a9592a83d23005e"
  license "MIT"
  head "https:github.comroadrunner-serverroadrunner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6abd0440111ef7c9e42a991305efb4d906093b3c676ab0d5c04210c2e726fff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f56b25a38f444d720c10a1284a3161b60c18f8380201ae992f6f76427f86791b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f48d1fd66d0bb9753cd98dccced4f4121e0b8bed3953cc5dc6cc55d7d0a4d1d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c35ba4b8b53dc42a9ff796e844725309e13bf019afb3ebffaebc55374b4396f7"
    sha256 cellar: :any_skip_relocation, ventura:       "43cbfc3be990600f13b1690d344dc067c53c2140f412c3fa2fb42a1febbb2416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a479fc880167bd5da7ca22ed21dedd6073ecbf78bae1e6e1ffc484354f853334"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.version=#{version}
      -X github.comroadrunner-serverroadrunnerv#{version.major}internalmeta.buildTime=#{time.iso8601}
    ]
    system "go", "build", "-tags", "aws", *std_go_args(ldflags:, output: bin"rr"), ".cmdrr"

    generate_completions_from_executable(bin"rr", "completion", base_name: "rr")
  end

  test do
    port = free_port
    (testpath".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp:127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}rr --version")
  end
end