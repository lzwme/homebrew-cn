class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.37.tgz"
  sha256 "016d1a2006fd3411c5914efb587112c2c900b9ff277b42249b69bce5fcb45492"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "213bfebe109f75534ec2b0a090df2de491b68152101a70d10f723926e32ffca3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "213bfebe109f75534ec2b0a090df2de491b68152101a70d10f723926e32ffca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "213bfebe109f75534ec2b0a090df2de491b68152101a70d10f723926e32ffca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb986bf30c1134dce7fb946888ce311498b1d669ffd1134c5f518b5040d3725b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cb986bf30c1134dce7fb946888ce311498b1d669ffd1134c5f518b5040d3725b"
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