class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.110.0.tgz"
  sha256 "01a7c827c2e28a7754558626408f62e38b23179fa35d708be19f59be7d262b79"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f70cce143534119586a52beaedefd206153cdae64a199052dfc51dd3a79522ab"
    sha256                               arm64_sequoia: "f70cce143534119586a52beaedefd206153cdae64a199052dfc51dd3a79522ab"
    sha256                               arm64_sonoma:  "f70cce143534119586a52beaedefd206153cdae64a199052dfc51dd3a79522ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5ece9ef008d3226634ae7e8cee3931442d34eb9b2567b86957bea16ef5579b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d93b2bcd31824c92e255664ed2f14fd223fe61b0fc1828e1b202c8ba2959de81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc7d70f0a357847b7639a03637f423855a8125026407fcd3c6849a02da699c59"
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