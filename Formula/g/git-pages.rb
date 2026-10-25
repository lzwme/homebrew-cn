class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/releases/download/v0.10.0/git-pages-src.zip"
  sha256 "460b1ac9efbd30f807bbaf651b916b855e3629b4350b8ab1542a5b7972707ae4"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a030c1f0f77603d230e2b78cdc692d21877cdb7228072f206619b3926196d49c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e7c441120f48d588a44d35cf7909046f3a7f1d6e11f01b0532c3939d47db06a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16bde249b47887046634949851aba9ab09343d4aede37deac4b957ab7849d0d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5904036bbc946db8696dfffcc2e98da57e056cef61fdc0c69fea1137e7f5dbcf"
    sha256 cellar: :any,                 x86_64_linux:      "96d335afceffda8e51c8d7d97525ac853b94b7be715b24005ba9ee125b9db82c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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