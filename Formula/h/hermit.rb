class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghproxy.com/https://github.com/cashapp/hermit/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "10c8f5c912988b74c5d7149e98e6d868889fe8be863ae9f5e0c7fed0a25c9f8f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5d7a46062959f47927ff19b34106c3c145629ee0cbb7e64da56f2e17fd8ce4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5541f695324d4fcef40b3dfc3b77822294f5d546ecdedea21fc60bcdfb8b2a03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dd4fdcbe8c68ea0feb45f39dc283f367e075272375953f13bbd3c3a9ed09357"
    sha256 cellar: :any_skip_relocation, sonoma:         "a79e1eb9ab879128bfe8deaac2adffbb8773502e2af57a3dd8565ce13fd79900"
    sha256 cellar: :any_skip_relocation, ventura:        "4506de79baffab055d6bdaf85b261ed59aaec806432fe7488c0d8cc67c2cd52d"
    sha256 cellar: :any_skip_relocation, monterey:       "a39320b4a1e2b196e4b775225eea0f9649ecf21f7ec2e24327844e6bcb2d316f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e48ac2d1a64bb5a3ee295ffac75b8dfccafb4f9bdba6afe8de91ab9f95612137"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_predicate testpath/"bin/hermit.hcl", :exist?
  end
end