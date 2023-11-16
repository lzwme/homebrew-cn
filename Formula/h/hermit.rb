class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghproxy.com/https://github.com/cashapp/hermit/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "4586c1957665bc6859547e44fe026f58cf527e9c40f7c1dc564a69ff8862d901"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d39c27c0ef2cabe4ca41fd54c982c4a9679b4de74dc1548d239df65e180bd5f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "360bd1eebf29ba67eeed72af5699d047a1abcb965488f3616306305064d7a6d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3482a90d8e4decd0ee5e2e3f0fd140c5ca8f2bd1165fd936432c6c509ed8c462"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e045cb4b4b8a6f78f0462bd610553b8b9ac6150824216f350d8bc3c082210d3"
    sha256 cellar: :any_skip_relocation, ventura:        "1ed6b5394b143ca8c008a46a8d2bb7fd48a570fc793fe5c6604ee46e33103015"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c49724fbe9d4f7d0f6afbc293d8cff2babe2fd527abf5db3099edaba3fa883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8590c540b3822ebb7966dd8b1a9eeec262c11b06a786af0cb8cda1bb2098d2e6"
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