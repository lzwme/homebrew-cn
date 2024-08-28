class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.5.tgz"
  sha256 "c0f74e971acea2badd92a2e44e308392e46962656125dd69e50304f6f542cec9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9394ab47eaa6f71d18dd8186ec4840d57a2dfd7a47ac0b8be780cf7240a616f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9394ab47eaa6f71d18dd8186ec4840d57a2dfd7a47ac0b8be780cf7240a616f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9394ab47eaa6f71d18dd8186ec4840d57a2dfd7a47ac0b8be780cf7240a616f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe0111795f6b8566306e5a1c50a58c877e48544d77fc794a8a72a7d9c7dd8fda"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0111795f6b8566306e5a1c50a58c877e48544d77fc794a8a72a7d9c7dd8fda"
    sha256 cellar: :any_skip_relocation, monterey:       "fe0111795f6b8566306e5a1c50a58c877e48544d77fc794a8a72a7d9c7dd8fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba1b624e369ac75b4039351607efbf2ff1d1898d7d218f4017284011c257454"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end