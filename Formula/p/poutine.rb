class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https:boostsecurityio.github.iopoutine"
  url "https:github.comboostsecurityiopoutinearchiverefstagsv0.14.0.tar.gz"
  sha256 "5f77df5275a7df91ed79a55fcb605735c894c94c75d40962d32010dfa76095f0"
  license "Apache-2.0"
  head "https:github.comboostsecurityiopoutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04550e0944b1fc187200fe0f22095190480dbb115efe4711165edcbf3bae89ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "529fa0a637ed9150747b32d27b2c1adb46c8ff5e0ab325e14728850b0d227a03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7af21883d1fe5addf882abcd6577cfa5574a1784a11b4c4e70cec1b5e0e53d2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "30d5d79e6a8ea75b39df66136f8d51421fbd8647792ce242fb8bdb5143adadc9"
    sha256 cellar: :any_skip_relocation, ventura:        "39fd2685c76cd16e3eccbd9ba70ae61812976b63833137be4b2bc59c79e44db7"
    sha256 cellar: :any_skip_relocation, monterey:       "8b1da75511bc121b70e3fa3381606ef510f8760985684302eec7d3b263d08b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c8713c259c1200361d847b12f80d0a623ad520db4a4b5bbfe3be6f9429623c"
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

    generate_completions_from_executable(bin"poutine", "completion")
  end

  test do
    mkdir testpath".poutine"
    (testpath".poutine.yml").write <<~EOS
      include:
      - path: .poutine
      ignoreForks: true
    EOS

    assert_match version.to_s, shell_output("#{bin}poutine version")

    # Creating local Git repo with vulnerable test file that the scanner can detect
    # This makes no outbound network call and does not read or write outside the of the temp directory
    (testpath"repo.githubworkflows").mkpath
    system "git", "-C", testpath"repo", "init"
    system "git", "-C", testpath"repo", "remote", "add", "origin", "git@github.com:actionswhatever.git"
    vulnerable_workflow = <<-HEREDOC
    on:
      pull_request_target:
    jobs:
      test:
        runs-on: ubuntu-latest
        steps:
        - uses: actionscheckout@v3
          with:
            ref: ${{ github.event.pull_request.head.sha }}
        - run: make test
    HEREDOC
    (testpath"repo.githubworkflowsbuild.yml").write(vulnerable_workflow)
    system "git", "-C", testpath"repo", "add", ".githubworkflowsbuild.yml"
    system "git", "-C", testpath"repo", "commit", "-m", "message"
    assert_match "Detected usage of `make`", shell_output("#{bin}poutine analyze_local #{testpath}repo")
  end
end