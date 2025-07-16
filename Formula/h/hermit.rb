class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.44.12.tar.gz"
  sha256 "5edb018d5a3ea8c9a0ff7b2b9b9f5510ed4f50b7302007099c6cf63d583c7c73"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d0303e836e3f6c8a5efc2fcad26ee8e827b951233083603a694778c8b40e767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d9332f16c54f2ed15c9fa6f5fc9574e9ddc03b03c3a0edc8b3f81729d3392a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68902f5d79b329b82aa6035411de67f43b664c4f2b38c5601cf429e56029b45f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cab9e88be067f5ea479201546842fcb4d24a0af4b58b5592c31f903759725c2"
    sha256 cellar: :any_skip_relocation, ventura:       "bf2fbe53b34ca3dd5db87ab5434f93b66014878d8c63231823996c229be6a33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1e0111bb94f800f8f3099605115e068a4ebcced94a766bdbb2d405a4d8495d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b33247c2370542fe947cb63a4c878273d0273c19ab7b5c01a1ebda35c40dc2d1"
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