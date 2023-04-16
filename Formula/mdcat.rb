class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://ghproxy.com/https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.0.0.tar.gz"
  sha256 "f3e432df3148f480a073fef97e6e1d1158e6efe89ab745422aa7e2071d198f14"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d685fd0889bd3d2eac74595574de8fd7473c4d0a41166f502ed7ecd6339f0e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cc6d0155d073ee907713bf44104014716e5add723ff062f59c36ce8582e9788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fcc410acff87dd3ac18fd9d30a24ecd048f87cb82cd01f4b258827ce4721369"
    sha256 cellar: :any_skip_relocation, ventura:        "bbf5800afca777c5145d3ff4bb3e4114a5a9ff68d9cc4a6cadfd0449fd694122"
    sha256 cellar: :any_skip_relocation, monterey:       "0307bf59eae89f77fb75d6c394bba296b13d30be00ed642f0b448c14ee8f506a"
    sha256 cellar: :any_skip_relocation, big_sur:        "84b82a20428355179c46c6590f68717d86b274a6e7ee39f54aee65f7112975c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd48c8c99e2adea6e84fa18af126632fab71b95cb434fa613f3ad5ff532db67"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end