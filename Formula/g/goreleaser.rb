class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.14.1",
      revision: "6bce54f02c901c4e42e699d35e66b4d82f2ce162"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f72483dc12a5f305f0bf4aef3a34613762f83c87fdf79d463940e36c9397d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90eee49ab55fef176094eb4cba0f16fc4fc5cb26028b75fadab6540849c83dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3b3d634dd41e92c55781c69e666254fa3cf4d9bb1cf92f1af0d78143bcdcdc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e21fd88aca75a16d32287283048ad359d920f930e8ec1338b7ff2ffd1238db9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc1012d18b184c743aa0b84085fe6cd808380fe47b18bc63f9ae7953d5c76486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3082a242e371b2f402a77bb289749d560c4d849a2189b875050afd60b0a22b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end