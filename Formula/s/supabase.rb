class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.117.0.tgz"
  sha256 "60ede92200f698a009d3bf11e9fa3395485965caf6353763b63c2c0ac6b40593"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e54ef1199887c1674dc80551cdd81641fa493cc8a7a1e24c2631aba8389459ea"
    sha256                               arm64_sequoia: "e54ef1199887c1674dc80551cdd81641fa493cc8a7a1e24c2631aba8389459ea"
    sha256                               arm64_sonoma:  "e54ef1199887c1674dc80551cdd81641fa493cc8a7a1e24c2631aba8389459ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d69dd191a534fb909a419936f4b53ad8ff9b78f15fafeebe1d9d98d611b0c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca1320a8cbe19d8ab9c1be92bfe7defb9eeafef158eb1e31bd271eb223ebf48c"
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