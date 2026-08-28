class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.116.0.tgz"
  sha256 "f9c9071515da5148c751d2aff2c8c3e1c3272458075b65d86e6d46107bcd3371"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "efb43fab5284b53b6ea2793685c6922ce7c7419a54822e4bfc25b3576b135edc"
    sha256                               arm64_sequoia: "efb43fab5284b53b6ea2793685c6922ce7c7419a54822e4bfc25b3576b135edc"
    sha256                               arm64_sonoma:  "efb43fab5284b53b6ea2793685c6922ce7c7419a54822e4bfc25b3576b135edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a17609b1ba7b2ebaa26c636091d2e3301b59583b521cce58485bf5044cf9f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a7cbc96f5a988818211a68cca723c7070609f843b0123784f4bc5e3fe034a25"
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