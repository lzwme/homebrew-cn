class Poutine < Formula
  desc "Security scanner that detects vulnerabilities in build pipelines"
  homepage "https:boostsecurityio.github.iopoutine"
  url "https:github.comboostsecurityiopoutinearchiverefstagsv0.13.0.tar.gz"
  sha256 "d36f1e5849599d5b56a8838818a1dc41e30e113a5f1a098607cf40b32e5639fb"
  license "Apache-2.0"
  head "https:github.comboostsecurityiopoutine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc8d260725a77263604bc08485eb37f1738577175e69c44043491289b11b2ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74ed2b5adbbdc796e284b38769bfa4bab796348f26b57279d897e658a508ada7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d7005fb53c259e8db333a56704e471c7bacd07a11e622550883f863768aa87d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d8af7029d02d05ff9c3f76e2727c8f63a752d9d04f7198b08d89433c993f3a1"
    sha256 cellar: :any_skip_relocation, ventura:        "78c635b84df8386a38c56639f0bee52ac8b7e8f0bac3e87d1b7a241fd4ff277d"
    sha256 cellar: :any_skip_relocation, monterey:       "deb3d82f09e410df4b11fe230790ea2ecc85d310487dbb206c0a16588c0cd643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0b9d689c1a7811a4e465afefcb7b3ef8f5b7a1d297035742108352b98f06b52"
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