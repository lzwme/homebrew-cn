class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.5.0.tar.gz"
  sha256 "bf464ba8c919487256a732d7aa06e8d29f9803fbcaabb001d2fa02f5a3488bef"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65547ea7af8dd414d0d33bbd8f1d6731faa623b36d824ca9e2400210c7456f72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc465caef910373093877a9af4d828a13552202874a6ac77df25d6e829d7884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3a24a554ff0c62f067d29a7577d7200670e0d562c6e17cd73ed1a51868f192f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a93691b5b133225bb91b5183edb9fd189d28fbefeb4cac606d424aa94086dda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e668b6b0dbe714ea8b8e17c6b1f02bd1eb24d38a5c8d5cf789d89b84c41d53ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eecca97038c75a9df38939c7fb96d444cd95e19f7da0c77ea820fe4114b024b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir_p "data"
    port = free_port

    (testpath/"config.toml").write <<~TOML
      [server]
      pages = "tcp/localhost:#{port}"
    TOML

    ENV["PAGES_INSECURE"] = "1"

    spawn bin/"git-pages"

    sleep 2
    system "curl", "http://127.0.0.1:#{port}", "-X", "PUT", "-d", "https://codeberg.org/git-pages/git-pages.git"

    sleep 2
    assert_equal "It works!\n", shell_output("curl http://127.0.0.1:#{port}")
  end
end