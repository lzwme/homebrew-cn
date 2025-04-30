class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.comcodesnap-rscodesnap"
  url "https:github.comcodesnap-rscodesnaparchiverefstagsv0.11.5.tar.gz"
  sha256 "87fc6771d28483ec6c05d5ad21bf54f9aede9564d6dded78869f1e904cee9e68"
  license "MIT"
  head "https:github.comcodesnap-rscodesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ae65958f6f4a185427f78b100b56bf07d680b0e4e8eba9270756eebe6f7f2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bd9e9c032ab39a3ec50fd7313b95113f70e2fadac9f00aa9cc3a129ed645d35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90dde118e286cfaf984a3bd4bce00c4ca61d140f335a1b1cf6e29a6e05bc3767"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcf4f978436e070dc9f2d791f64107ad20ee21060ac20d800d2478510b9eca00"
    sha256 cellar: :any_skip_relocation, ventura:       "8936fc7bd384aa30e9fe8c2dc1fb869f1099e2628c3a1d04f8ee993ebbeca02c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6be935da968e8dcd15d516972e008f25a50ecef732650f2770a641f282b612d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca26c183f26db7835590900a0916f7800725204e8cffe32fa26d292ca50e87c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cliexamples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end