class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.17.tgz"
  sha256 "eabdeb5c40354ed3f5077cec4299c6cda7455022d582325ccdf72e5fa930807a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7c74eb07e35de7cbb54da746d0ce2f115114cb80edbec68a631d8ba92c3fc90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f653b801b9a609ec940df982d85811b251838ee7bb63cbbf7f27dd2d2750961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f653b801b9a609ec940df982d85811b251838ee7bb63cbbf7f27dd2d2750961"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cae95f69904538d827c64bc5edca238c131297fa2b035197ddd3a7975faf9ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4508eb80e7dcb5e9addfc1af37914b28fb8535639315627149c815db5ae4035b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4508eb80e7dcb5e9addfc1af37914b28fb8535639315627149c815db5ae4035b"
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