class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.3.45.tar.gz"
  sha256 "73f524c7e11d710af969ad3c2128cfa6fcc299d8575146669693b38ff74a20b7"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31815e4ba3372190074d38a7f3ece005f17216344557ba24b78b5c23f9e12cea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f51804814d606307f3e232ddd4d1e7154047e55f99a28ffdcf5e2e45f2417c1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4114ebef91f88bb961127c635573dbd12a084603b54fc8a916b7d1cb9a22cf98"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea8fef5cb955f3e6f86ad99af86d20778f97dc3a3a6801825a63f8c4d2889763"
    sha256 cellar: :any_skip_relocation, ventura:        "23f895c414327870778db638818b2c3528747f952069219bc69bfb8fe67eb037"
    sha256 cellar: :any_skip_relocation, monterey:       "0176e975a14080608513f4a62cf832d9c1706ca29579d956945ed71dc4b9469a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47932026372269fda9e449fb04ead99919bb280788b04c75aa61f2a90fbe7e4a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: ldflags), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end