class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://ghfast.top/https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "6d6ed3aabf5e620e2d15b722dce5bd5cc4482d1e0027d5a1d0e96f9678d4e7a1"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb4062e68e265007de53615e418881fdd3dfc0e4a03056f8f6dd6b78cf957604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5405bc00bb2f0a8b9625c3216f25e73816e5339f3794b445986be9fb3b204b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a69f593fa631089b7be74e67f96c3b7dad50d79aafdd5a2322fa6391ebf734c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3a90ddd84e7bae1756e6e74822436b95e823bbe7af424cde725c403cb13bc4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b21fca2ec4444781faeb7b27887dbbf8d16cc79069fa471c400f29109a423fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b46d04f9892bc910189e7613a9daa79c525aba42effcf351a2fc81638a66046"
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