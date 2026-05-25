class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.101.0.tgz"
  sha256 "86fd9bceb780e178a2d7906aecff64ba05fe62b20248f9782f56ced8e64fd334"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2f2768e9dc29ff8e59e429d31d78e6475a89f842d73c42aff064cc39c62b9ff0"
    sha256                               arm64_sequoia: "2f2768e9dc29ff8e59e429d31d78e6475a89f842d73c42aff064cc39c62b9ff0"
    sha256                               arm64_sonoma:  "2f2768e9dc29ff8e59e429d31d78e6475a89f842d73c42aff064cc39c62b9ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "740e0f3a670c42821e3779f81fd3098ca56e5a78a48492a4dcff21e5f23b0c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e7137738b33343bc946bea9bdda6676fba19fb466c7a229a242b9b17e309ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531908bc0cf2c70ff6121cbbe8fb534c709f58fb4ed247de1170ff3fe5b6e9f1"
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