class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://ghfast.top/https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "765f0b6b0f141bc6c0ebdf89b77e9aa0355cd557e6cfce9d0e96e12bfab0b8d6"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76172025b5f88088a8e2e232c1a4e51e5e13ba9bcaf8bb0c2e43e1eeb1a52005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98b67b6119c44a0a10a02d08863ad9414e004d0fd5ec9b5e626a86e638e5314c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7982d4e0c55d42a3eb57dbc0981c56dd4eaef65d3313d2a046e7737d22b88a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0192b1c5a49c4616ce3e39d840ce33d718ec3b599d2f0b0b2e999f51f8f2c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93b7d16c363e9e0c968977e794ee90c9677cca5c1a511990859d5c85ee5106b2"
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