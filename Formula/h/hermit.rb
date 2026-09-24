class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "04c31c3413bbff50b910182e0c26f660fa37c4cabf31807fb8157ce743e1be64"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd4568dabfa314e22c6914f6255986262b48838ff6a4dc663bc34ac303c5ecbe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6371eff9a0c3c8c7aa8ab435c354ad6865c58cb162cc90eb8a817d7d16282644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de25f623e3838b7f7d7958e6f3a86545654b2fd19e66e4341a414b1bcff26bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2727af108bae8208e508fb2cd4333820ce8c00071f2d10bb8f82cb8993f7a062"
    sha256 cellar: :any,                 x86_64_linux:      "73c5732d0b172d45a1d344c8d7c7141cb91063e47aae2fecb30e36aaab547052"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
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
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end