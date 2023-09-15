class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "03ce032d963908fe2f136bacc6df99e7920dc13f60ccbe7790e5955687ad98a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80c96bfb60aecdfc8e6c7d193a49a6f4bb1273797c0e2bdbd799053f3e4aa919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f53b92f0818097ce45233c0c4f360f5e49eaf3c102bae699c6d5e64ee7f0aca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8cfe246238f5640155a45c12da62cbd2ecabc0a1f8d879b4af9fa24a335abe6"
    sha256 cellar: :any_skip_relocation, ventura:        "286b8232d39c00f153d8a421605c86219fdeab98a2a2c51a136c45b8317138ef"
    sha256 cellar: :any_skip_relocation, monterey:       "c83b579950ea966066e23c475f70d0595581783b1b32813e52710fee6ab6abdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1f7a10fde5b6407461d3f34afbbdc7812e888f608a18b2cb58406ac60da759e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc6e75a4f42b93baaf32eae4c22a39bc46efbde84dafeba9c3034e3d9930b63"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end