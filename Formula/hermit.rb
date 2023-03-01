class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghproxy.com/https://github.com/cashapp/hermit/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "4a50bf5baa5727bee1c5176b252eb4b713af3e3926031838527f26ec40f2403b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85564f8f873119cdb49cb98b84f600fa9fc092564bd041a9cf5b2d91550241c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54d681a763cbb21784b22cfb309bb4c0f2d6b4a96e1a0bd260c0068b2f55764e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0922bd4bb417ed11179b6fd7e88565c72c9068d7355df3f307518bb4b27840d"
    sha256 cellar: :any_skip_relocation, ventura:        "120ee4a7991ce92e5cb09c5a29e59734a094d2a03ff3bd296359a42720b7ec01"
    sha256 cellar: :any_skip_relocation, monterey:       "dfea45aa8cf19572c4236e6b1b24b559eced6e65f432e9f3af712e4249122bac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2308fb0661e4b3ab821a45d6e52b6eef4d05022cf5aea18dc9edb8f239a55af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1595f6723098d9a4fa32e9f1bfd3bc114c940cf7b1d65025001b8e02b887f5"
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