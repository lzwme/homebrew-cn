class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https://boostsecurityio.github.io/poutine/"
  url "https://ghfast.top/https://github.com/boostsecurityio/poutine/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "47df1e9249d1eb71efb165186117b3b94fc238b2aca992cab484b2cfef09d234"
  license "Apache-2.0"
  head "https://github.com/boostsecurityio/poutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6dc99527e0bfa23cf6c5c0bbc0d9af7da4aebf0004bd7e1220dec8c7e78f9d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3b3d3c36d5c461e1007590d35345d7eb81c5800cb3d37c5c580d03621dfc20f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14186abf582135b83f727833e3278a3706d9db7b1e1865f13e2a9c4088efb166"
    sha256 cellar: :any_skip_relocation, sonoma:        "efa2e95c3c2c2de1c4ef0fde0b947de7ddee8a14f6eff03dfde5b24d4c997a4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cb638756a342401d87e753c70ce1558c1c6a1f1ad8b83996b6bd51ca0e0262d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea35864145bd6ffe0ca3258de70f886cc2af00ed8b7680484b0c4abb9adbf1c8"
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