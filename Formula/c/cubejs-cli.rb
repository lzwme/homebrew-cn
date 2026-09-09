class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.35.tgz"
  sha256 "7ed13ad00105ab7cf4d52b62548a85a1b3518b47f567e567059b4007f98cdc8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed81171ab23aade257291dba53eeaff7e4a52fc03138a08b0f7d661848d46799"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed81171ab23aade257291dba53eeaff7e4a52fc03138a08b0f7d661848d46799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed81171ab23aade257291dba53eeaff7e4a52fc03138a08b0f7d661848d46799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "873570f70fcdc3c203f74456d1c0a8a9750928b48ec59df9164f9ccc5b7f1c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873570f70fcdc3c203f74456d1c0a8a9750928b48ec59df9164f9ccc5b7f1c60"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end