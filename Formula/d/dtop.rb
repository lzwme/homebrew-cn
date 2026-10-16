class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "4d80d150a955f552d966869ae6568786722fb80ddd36df9f85b09580b1bb7d83"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "743707d3ac1b0732864b7d6e3d5145b76647f531c3a14d1a41ce62770ad134c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "866e8d8215e38b87def11e98a2b30b09e8775eb39ab5d99efa7213b673e5a10c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa9108fdac4f13a478422231fbb7c8db4ed1feebdd34ee546156a92433fe0a5e"
    sha256 cellar: :any,                 arm64_linux:       "f01344fe9d9ef95a67cb58a02f0d0b7404306be0b5c473fea61effbf75d8d545"
    sha256 cellar: :any,                 x86_64_linux:      "8281169bbf45798a3da6f1a34df97ae4b7c1ef755078dbfe0e440a23378804e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end