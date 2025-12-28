class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://ghfast.top/https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "91fd5c703e27385809fc40deb49af3b3de2feda47bf1f75fb6c1065602a880a8"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0ae3ea67af3c4dc280cf24cbf835d3eb2f88521659926d6c987b766f92ff0cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b68a835b93ac58e18a181cf4f50e27d8ffc48a3242a1accb074ff3adeefb88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8487653d49c2c1325c72f0697805c800257701d12713de55c842eef12e5a645c"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d933a2d099134ac47344efeec48187276ead6e4225e7e7aed564aab92304cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99d0b1371cc6d07a52492efda264388ab395b2d7a8bcae53649b62f1e35da927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "178e15e54709c0e056af8e6f5089cdbc9cefbdda6e56836ffbb1735ed5bf1e79"
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