class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https:boostsecurityio.github.iopoutine"
  url "https:github.comboostsecurityiopoutinearchiverefstagsv0.15.2.tar.gz"
  sha256 "0737ec8b06e810c841efb6cc7b9254d84ab68024056a0de1b47a9ba95a47cb38"
  license "Apache-2.0"
  head "https:github.comboostsecurityiopoutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a9b993f109cb405560b6fe56ee96c37821799136e1cd17a8c3cc59e019166f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a9b993f109cb405560b6fe56ee96c37821799136e1cd17a8c3cc59e019166f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0a9b993f109cb405560b6fe56ee96c37821799136e1cd17a8c3cc59e019166f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc03b2abddf13bc45943f1eb9f418fe02d130c5181a149649f9313b61c601ed3"
    sha256 cellar: :any_skip_relocation, ventura:       "fc03b2abddf13bc45943f1eb9f418fe02d130c5181a149649f9313b61c601ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923a996afe2139aa7f987968f4b6b8c39792cb8f9124afd08c800b3e550bd7c5"
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