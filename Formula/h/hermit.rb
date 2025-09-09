class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "7c9c96d0f2522b3d0f46bb26a0777bb0ff9435ebc3a7a7c4ad847402a40cd9f6"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29605bbef38380bed3774f223269e66cf7ff6abd13db7a3eefe274fdb102e77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2317433d6f57c3de74b49bf64ab584bbd240fc2efa58adc6917e6784c7b810ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27f0c0aba5776aeda98bc33d51ced799f6b9ca7dc054963fbc6d5ceb1e344dc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "780997104d2a76c42912156be7f6dade648016f708c5c864cd2be9691714f215"
    sha256 cellar: :any_skip_relocation, ventura:       "0a2b80b5c1eff0e09930c5e59711e21c0278e5f2865e44bba13783129bc05205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef39f50f38c0ff1b7a369963faf9e7947d0a84cd68bc546054d7ccc08a297dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e70068c994174fdd142fe54982397d9cfc8bedcb5ad92d51166dfa2eb0711504"
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