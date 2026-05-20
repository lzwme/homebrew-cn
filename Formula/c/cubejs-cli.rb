class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.47.tgz"
  sha256 "ce85c8ce6ac9853540df3fa1cbf3a17f718ff2231d95c865d6c5638f1d25d982"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e0b7c2018acd7fd52c42e7e70bf08a43c9f0992c7731b45a65711be7e1294d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51361a2ecab9348bc9a45cab4698ea8e225dabddb1eab7a065edcd014d3a8eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51361a2ecab9348bc9a45cab4698ea8e225dabddb1eab7a065edcd014d3a8eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2b444917ab17bfcfda87b1fa310780610b12ef3bc6151730cb9dbd901fc4761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9e20c45415f18a3cfc221b6338a31a3867121c2f4d190b912a895b1fe46af10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e20c45415f18a3cfc221b6338a31a3867121c2f4d190b912a895b1fe46af10"
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