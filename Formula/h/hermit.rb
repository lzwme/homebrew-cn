class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "9507b69e05d4bbeee9bc64adbbe407cc93a7f5fec79916f2e89ec43c3f599ee9"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6196f5c9def7948ecebe6a913f97f7d76bde64ed1493a520cb63b16ab3062b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c4d9f2385ae7760b09943416246e52cbdd4f3084cc7f85f78fae8e9a883b7e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b57838cfee978cc116117d79d9f46a69657daa25fc9a0e5abca0d98bc80788c"
    sha256 cellar: :any_skip_relocation, sonoma:        "74638e924f6e0771a7bc3551a9b766b8e09af731ae64d1e7d181c1c61cf69112"
    sha256 cellar: :any_skip_relocation, ventura:       "c5345fe22fdaa6e554d41f6cc68c84264042cdb2df2e18481e7c5d9476716df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a6273dfcd79c6b5c2f4061d951a1fa44fd6f9392c4bba215f69ebef86e4a36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eefec9756ab10ca561d7391935d3836457cdd36927775cb4866eb5d06a957be"
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