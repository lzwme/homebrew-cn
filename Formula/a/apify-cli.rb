class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.12.tgz"
  sha256 "601c1398cd769a355288c7ac36e324f9fafcd1bc68ee6bb77f0f12b5c2d8182d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb3782bea6fd00a4759b996e023867a387c68c87770c1194e8e1afa86b184a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb3782bea6fd00a4759b996e023867a387c68c87770c1194e8e1afa86b184a7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb3782bea6fd00a4759b996e023867a387c68c87770c1194e8e1afa86b184a7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20f4ded61fec8ee4816007db4f924433df134cbf12784f7650a122e872e4327"
    sha256 cellar: :any_skip_relocation, ventura:       "b20f4ded61fec8ee4816007db4f924433df134cbf12784f7650a122e872e4327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02cd831cc08a94f773d8d47fc9f6a5289408cb73ab45c8568cee92f180c4b828"
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