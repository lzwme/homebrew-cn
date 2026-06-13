class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.106.0.tgz"
  sha256 "ade939178b1eae9f5b4e06d23fa181501e82f04ba751d35cfd5a9cfb3a121580"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "959153b928cce36404c99e412f99ae17fba81a37999851576ff4d97765e0aa5c"
    sha256                               arm64_sequoia: "959153b928cce36404c99e412f99ae17fba81a37999851576ff4d97765e0aa5c"
    sha256                               arm64_sonoma:  "959153b928cce36404c99e412f99ae17fba81a37999851576ff4d97765e0aa5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b8a90c29f86bb75e66bbe2e62837dc92f96235163520b44d88e6d55896b9da5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72a6478d8a6cfb824c3bf73b3f845f2bac2c103aadfa77eaaca297fe111b0983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "742121407dd976be98a8010330009961b1efa94be96be1866d8a748577398946"
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