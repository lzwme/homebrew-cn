class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://ghfast.top/https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2deb9b442c260a4f0972276c6223e450bdfd10c1487cd4d9a1d1cad189eee5a4"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7f8253bcb6f9d1dea22de7abf78f77922a22ea2e2dea55f85406d2c1e8317c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7f8253bcb6f9d1dea22de7abf78f77922a22ea2e2dea55f85406d2c1e8317c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7f8253bcb6f9d1dea22de7abf78f77922a22ea2e2dea55f85406d2c1e8317c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "998534f72dbf46c05c800797fd6e533402f03aa5ad731f7a99103c31dfcfe2db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed8d280b5464396f86ab2a951d15c6eb0781637a9b888266478c6d94814683af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f3c66b752040136af0aa0afdc3964cd6b6ab791def8c993a2d5d900b1a40ae"
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

    generate_completions_from_executable(bin/"poutine", shell_parameter_format: :cobra)
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