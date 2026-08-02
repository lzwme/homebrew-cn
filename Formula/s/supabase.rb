class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.111.0.tgz"
  sha256 "17df2a4c8c59bd6bbbb1ae03bfd6eefc31bef3ef47cf48ad927be7fff12f490b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "dc08f7d56e126a8b31497306b17005704fb38d4f18d291113b1da26766901332"
    sha256                               arm64_sequoia: "dc08f7d56e126a8b31497306b17005704fb38d4f18d291113b1da26766901332"
    sha256                               arm64_sonoma:  "dc08f7d56e126a8b31497306b17005704fb38d4f18d291113b1da26766901332"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f7322c5dfcba8f540d4095e38441131814c086f8b4ef84805235704b34b941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4068c67572726cf671c085fbfd0fa44aa4c8daed7693b5f04e25c80050b422ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e4d54a48576c35004419c56edfb0439cf0c279d484724b907925d7e45c6d45"
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