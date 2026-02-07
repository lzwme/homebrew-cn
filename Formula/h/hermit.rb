class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "9d7876183a5d5d5c0eefda566d8212eacdf5238fee9375cc4625a2b75aa76ca6"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a7dc34e2f06dda0b822d5cb0b29a8f78d68c3070c55a81bcc7c08bab8469199"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849eb08a08c39ef4d2dd20e55ac84f2c67420e8488c52eb10d8a454c366e3b9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "339361003c7de9ee6f662a0300ff134ffa77c0bdb1ef34d2301943a8d109585d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a6136deb87f28f46a5023b3459fb6936543373d94c3fac8f42f49216e1cb0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14d7a5ca7e726e3cc7437e87ab5f291ff657750874d29b6d894a4a7376c24121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77513c1bcfb870cba3b171e005e1ecc055dd9017dfcd5abff732eac7ff33d6d7"
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