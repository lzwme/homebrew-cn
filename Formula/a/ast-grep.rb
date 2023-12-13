class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghproxy.com/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.14.4.tar.gz"
  sha256 "795c3088f8b83f974a441d79648cecbd1567005a6572f489d8ef77bd8649f83f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "786cde120367bec42fb90fde94cadc946f2b297b01bc914dc2dd7a3a29312514"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0788335191c1bbd8984b75186aa139c344cf4f425460f5f1faa6d2c7181e4d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c49c268ad918c278deba8e4b560d44421091c5eeacd084ac330f530cd645af8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d572445ff1fa69071b03da9b0114aa89a98e96f06e3d7b80f39f44674cdb0ef"
    sha256 cellar: :any_skip_relocation, ventura:        "4ccbb395ec55841d2769f3d91253ea8fa65b8c6ccf6485b6acd6ef3607a4153b"
    sha256 cellar: :any_skip_relocation, monterey:       "40afb9d192c33cea22f89f74f5839491c6d139a7b572d3d9b2020fc700acc2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe26f47281ca4902ab2030885e2a3e617af7c89d4743a64e6d30fd2f0a29edd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end