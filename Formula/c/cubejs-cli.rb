class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.20.tgz"
  sha256 "01398d2acbc4d7884c756b3707a1e8ab14b0b4e669225ca2c33736cd60a68f90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94dfe34d07888e5bc7b178aeb1a440d88dafef0f4b6f2190a70b92706edd2b93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94dfe34d07888e5bc7b178aeb1a440d88dafef0f4b6f2190a70b92706edd2b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94dfe34d07888e5bc7b178aeb1a440d88dafef0f4b6f2190a70b92706edd2b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1f346c5e4eb8d641fd0cd700d72762c30a7b1a4b10b94c4f17422e0ca80237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d55c317ce2a5ea5934726536ef661eaa41b7043855f773f248e5bd99dede3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d55c317ce2a5ea5934726536ef661eaa41b7043855f773f248e5bd99dede3b"
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