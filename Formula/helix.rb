class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://ghproxy.com/https://github.com/helix-editor/helix/releases/download/22.12/helix-22.12-source.tar.xz"
  sha256 "295b42a369fbc6282693eb984a77fb86260f7baf3ba3a8505d62d1c619c2f3f4"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9682e86e2bf301c945c77fb92e31606af64261483046f8efdcfd867d7fa0883d"
    sha256 cellar: :any,                 arm64_monterey: "286b20ac1d02cea45262328602fb66476c6842c5042fdf16a05702893b28e5cd"
    sha256 cellar: :any,                 arm64_big_sur:  "ea0bd7cd2c49c6f21f561972962d8d6f13c2431929024c8a31d191240cbd3a12"
    sha256 cellar: :any,                 ventura:        "6752baa1f900ee7b74ced053bcb7b5e5ac00dd8d823cf5c8dd8afab7dea46023"
    sha256 cellar: :any,                 monterey:       "dcafc9eac338190380361fe820515fb2745af1e6e044708853847fa912242405"
    sha256 cellar: :any,                 big_sur:        "859393abe2375d95c1414438f3550daa9041c430b91173fb37acb6e35312b6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06a540e98ac6c2153badcd1ebbddb65bf5767f8434a01810b7a9030992d1de17"
  end

  depends_on "rust" => :build

  fails_with gcc: "5" # For C++17

  def install
    system "cargo", "install", "-vv", *std_cargo_args(root: libexec, path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    (bin/"hx").write_env_script(libexec/"bin/hx", HELIX_RUNTIME: libexec/"runtime")

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx -V")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end