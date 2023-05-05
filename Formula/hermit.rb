class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghproxy.com/https://github.com/cashapp/hermit/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "ca85d0ee0fb71491aecb68cd2b12db465a2903fb940ac8744005cc5ec6c409f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1ae234c673a9ab866248e747ac4975fdc9e7fbf15edc70bf4cb5c30b9c812f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8b3f4abbdb472f1707f508ee8ce14e615ef471c5e4d0f157026d2b4e236b08a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7fc21b0ebbdacd7879699928706407a292b6029adb79409fdb7f8a3a02281b4"
    sha256 cellar: :any_skip_relocation, ventura:        "95cd8f50159428ab9c4c8e4ede3f1d7bc413fa80ca50b55456e60b472800eee8"
    sha256 cellar: :any_skip_relocation, monterey:       "ff69d56d56e38c0201ce1f23ea8c7357e8b9850621c1a5d7baa5f77b1a735c9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf58b67cb1fcf806eb044bcb9a9b7ef8d5e1f142657062dcc2cd7b8273e9d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060f6d363373f9c8e6be1854cbbef3f4941d10e6e79430cabba28cdac4b7d1a9"
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