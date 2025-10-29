class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://ghfast.top/https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "8e29a08e04e03724c60c51e6e686919b5e0e8b7c01aa0124be5ccf9f5e699530"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84558e85decff1d033539fbce84511c63646557f8e4a085fdfde27b426050f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c4002782960fb1290b911fda1fadc1345835f17a8d7b5c4f31cfdb26cb2d08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377bef36ad3d9445c45cd6df6b12127be289d649d5b598242156c47dcd570626"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8456c664733dc38b9a6baf630c86f9541e01f1ccb6597da179db6fa97e51e79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa991826d2bdf85b1d42c295419f91fb017e682597b0539239f0a1f19b3b0ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4df9eb690c4a0d89d9340ae172da831c1cdecacdf84cfe76bdde770f6ece63"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"poutine", "completion")
  end

  test do
    mkdir testpath/".poutine"
    (testpath/".poutine.yml").write <<~YAML
      include:
      - path: .poutine
      ignoreForks: true
    YAML

    assert_match version.to_s, shell_output("#{bin}/poutine version")

    # Creating local Git repo with vulnerable test file that the scanner can detect
    # This makes no outbound network call and does not read or write outside the of the temp directory
    (testpath/"repo/.github/workflows/").mkpath
    system "git", "-C", testpath/"repo", "init"
    system "git", "-C", testpath/"repo", "remote", "add", "origin", "git@github.com:actions/whatever.git"
    (testpath/"repo/.github/workflows/build.yml").write <<~YAML
      on:
        pull_request_target:
      jobs:
        test:
          runs-on: ubuntu-latest
          steps:
          - uses: actions/checkout@v3
            with:
              ref: ${{ github.event.pull_request.head.sha }}
          - run: make test
    YAML
    system "git", "-C", testpath/"repo", "add", ".github/workflows/build.yml"
    system "git", "-C", testpath/"repo", "commit", "-m", "message"
    assert_match "Detected usage of `make`", shell_output("#{bin}/poutine analyze_local #{testpath}/repo")
  end
end