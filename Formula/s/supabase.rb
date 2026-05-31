class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.102.0.tgz"
  sha256 "f90cba16ce6d4e2627a9fb3c5025f08168a9cd97f452015226a81d637621b941"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fcdf0f309e4365a7316d537b3a44ae9212de71ce0a7487823dce6a53b513e909"
    sha256                               arm64_sequoia: "fcdf0f309e4365a7316d537b3a44ae9212de71ce0a7487823dce6a53b513e909"
    sha256                               arm64_sonoma:  "fcdf0f309e4365a7316d537b3a44ae9212de71ce0a7487823dce6a53b513e909"
    sha256 cellar: :any_skip_relocation, sonoma:        "88d570261254e58531fcae8ccb66bb2e73db62c1b4d3f16b520302ab3ad47d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf4704e1bd6589d6da1339fc9f7304bb76bdd5c6a2cfb90fab73588b5d4fa2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a76ea48ddd0a645ce65f2e2720670dc08963c22c108c06e6c8224553e743933"
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