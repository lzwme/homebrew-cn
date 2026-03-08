class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.6.0.tar.gz"
  sha256 "303151ba41f9590f22f52f61e66bf2d061a16031435b8bee1a9e14ff3e6a0183"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3fa9b6e27ac6353b944bdbf252eb04bfce1d4d95cafb3be98c5104fc43466cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d1c4165c3f8b8cc25031e7a9bbc89501a83c39a9e47b776863d7105710d02ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64055ab13884b145b1ee09410febe6ef61d2d9c5597a157dc92dec985b976c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4aa1ad25b1ccab4ba697bcb3b70c9ba795d63187231628459d64977a3787540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff45517c3b628d217484ac304829cfe5733d9f6f59a20126a4732f427b872d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81e4a554f7e17296f30556bdf38e99907f408b217a3c09f846168f262db07bcf"
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