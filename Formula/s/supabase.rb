class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.113.0.tgz"
  sha256 "cde97e29dbaf2ef89c61292edf296649bd4a5fd14b3620d7c8c7068b0a9696fe"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "19f6f47b30d34ce977bce75c61cfa4e90c33b376b1235dd25a884bd32049fbb3"
    sha256                               arm64_sequoia: "19f6f47b30d34ce977bce75c61cfa4e90c33b376b1235dd25a884bd32049fbb3"
    sha256                               arm64_sonoma:  "19f6f47b30d34ce977bce75c61cfa4e90c33b376b1235dd25a884bd32049fbb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bb1ef8cb187b95e5f856e5b07340cb28207cf06650616df8c9e392d9889c218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bde64b5710c665e0ca1028e59e93bc20a78adfa30b71abb00740de21aaa1c500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "049782d5601776a9dbcd611da3d12c24f766b98b9828a5cb2af2ce459a63fedc"
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