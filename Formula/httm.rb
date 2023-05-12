class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.26.5.tar.gz"
  sha256 "5f841dbd8c10763ddc9651a90070a7d26ad2f3ffd520fa63b9e975c81801d8dc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75a95a859f2b17bf4c6e0be349a567c1b900919dfca97f2dbfbbc59fb3b63693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f905d27682f57a389fee2d06a585d5f7d405074e83ea73b551de2d16fe5dc36c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c48b3d2daac58f09153bc5e1906971040975a61d44c07668e4ff2e4e2c6ae984"
    sha256 cellar: :any_skip_relocation, ventura:        "8db858aec9df6605633148282a26cf9c96a0bb8ba0d26758a9622efe7459eb8c"
    sha256 cellar: :any_skip_relocation, monterey:       "92f9aa7b794d4bbd3910c256203ee74e3b335626cca118a3ed7e37f93615738c"
    sha256 cellar: :any_skip_relocation, big_sur:        "826bffcee8b48f4b04e5f1b54a580e7e13d5e229d24637f5a40c8d235bc103bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0c29c2fe1b1e60d77903ae14ddfc6501a0bdf601018f564455284f0af3380b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end