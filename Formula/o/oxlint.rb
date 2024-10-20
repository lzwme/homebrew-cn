class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.10.0.tar.gz"
  sha256 "f21db5bdc1528ebe7aac83372d915c065db38d333cd3eccc8e17d94c5f8c5e7b"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "177f8599d9e498e647ffa8ed67fe513fa55ef2a170cc8c8d2612c04eefb57f97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40a789543d9e7a80715bf455edab1dcfd9b32f53ff0247692af7be706d6d21a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2aef1e15500a1e651feb9581123827f4dca6ebed75ada6395ac2e6337a105542"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff5666e937dfa75a2657b3d2d1e41adaa2f48d4470b68e6d2717d10b8fcaf62b"
    sha256 cellar: :any_skip_relocation, ventura:       "8c6bd0748950d009cf4c22c823b70a87602ed60f964646b30b58e401c1a3b6e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae3c2ee89a1f86282614dd2a54c32035e3702349fcdc6c8f1f5aa90d59eee5e6"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end