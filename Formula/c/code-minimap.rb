class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https:github.comwfxrcode-minimap"
  url "https:github.comwfxrcode-minimaparchiverefstagsv0.6.8.tar.gz"
  sha256 "c68d4387bd0b86684a1b7c643d6281b79e018da318657254f2502ad032d52355"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "263eea4b76f60214200778af55e486ed9dbc84a12c2673a8244e6da19e86ab62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa5d1d90bb9546186c5c5b94537729b367cab21eaf55bac39f2a43a411e71130"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f08906475ed671f2dec6f146bb65f14ed0460a893ccee1b36a5c036c1d1385d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb6e04b1309f85a6a040387c9d3051d2a9ba541bc9347219b928fa8cb2c7edb"
    sha256 cellar: :any_skip_relocation, ventura:       "296d784e3e55546a8df653b9e971e0758ba20aff12d37093dca9b3d787073521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c0a20dc3254df3f0f3793a781c82d22c9fb57ad5e9c5344168cb5cde7fe8e7f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completionsbashcode-minimap.bash"
    fish_completion.install "completionsfishcode-minimap.fish"
    zsh_completion.install  "completionszsh_code-minimap"
  end

  test do
    (testpath"test.txt").write("hello world")
    assert_equal "⠉⠉⠉⠉⠉⠁\n", shell_output("#{bin}code-minimap #{testpath}test.txt")
  end
end