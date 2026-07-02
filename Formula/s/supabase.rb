class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.109.0.tgz"
  sha256 "f62f049dbfcbf5a537ebf7107d9db0e8044dbd663b842a2c3a674420b54f9f31"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b817a99997b881478ff5e7123186d2cd48b909d54fed4ba95b4916e87e00f099"
    sha256                               arm64_sequoia: "b817a99997b881478ff5e7123186d2cd48b909d54fed4ba95b4916e87e00f099"
    sha256                               arm64_sonoma:  "b817a99997b881478ff5e7123186d2cd48b909d54fed4ba95b4916e87e00f099"
    sha256 cellar: :any_skip_relocation, sonoma:        "e71a7190a9a45c6299b53c321dc2490871e47b2b89ee6ed85a45f2dfac139460"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "485e4734f0b54addeb0343c25f94ad89c7cb10114e14a687e12ce301b039e552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1514bc2b206db4b81e690fe842ef027b1aae2bd50606811306f6b8e28b5244ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end