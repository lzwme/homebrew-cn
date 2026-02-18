class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.49.3.tar.gz"
  sha256 "82cb3063ab88e724340595bb2b15158008ea28c10e34c8fdb05617f2c8c210ef"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc0e843bccf88fdd02d71b5f69a8d657e224e306d3f9a764d27e4f47cc993ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95618dd85e72b73ec22982ab820658ec94163ef8f523c37037690bc5502f6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a044c9049ef6967bc65c4d7763a720490887e45d78361b2fd3937babde77225"
    sha256 cellar: :any_skip_relocation, sonoma:        "efe2e428007da1697cb84362aff4c23d5da2d9aad40bf4fc6e5cc15688c9fcb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2af1187e4cc94f4f331e3bfcab0425930f77c42ccfee066db0e9e1763e7d81f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec86c6d50252aee3416050bd3e1788d45da38dec5d77760c6e2dc82187bc459"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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