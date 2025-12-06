class Nuxi < Formula
  desc "Nuxt CLI (nuxi) for creating and managing Nuxt projects"
  homepage "https://github.com/nuxt/cli"
  url "https://registry.npmjs.org/nuxi/-/nuxi-3.31.1.tgz"
  sha256 "e15cf23ab7e05dc6024cff57235c39cd159af88eb3341e88784a759a6d929037"
  license "MIT"
  head "https://github.com/nuxt/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0b58c38b68edcdfec1ed471b19b06449b3700d150d7d5e5299287491fbee91a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # Both aliases should be present and report the same version
    assert_match version.to_s, shell_output("#{bin}/nuxi --version")
    assert_match version.to_s, shell_output("#{bin}/nuxt --version")

    # Perform a minimal project initialization in the temporary testpath
    ENV["CI"] = "1"
    target = testpath/"nuxi-tmp"
    output = shell_output(
      "#{bin}/nuxt init . --cwd #{target} -f --template=minimal --gitInit --packageManager=npm --preferOffline",
    )
    assert_predicate target, :directory?
    assert_predicate target/".git", :directory?
    assert_path_exists target/"package.json"
    assert_match "npm run dev", output
  end
end