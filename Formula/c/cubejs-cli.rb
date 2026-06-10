class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.56.tgz"
  sha256 "5800626982d6e3cfa059cfa64a37fa22d6d2e0a1296ec214c0c540d009a17753"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d60f53e4f9512709b9c98ae6d9f7c7b45d023d65340c973459e7adb1fba45ba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "580e89f2271b63def2d52bb685c32a31fbad772725198fc2275edb4ba9b44037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580e89f2271b63def2d52bb685c32a31fbad772725198fc2275edb4ba9b44037"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b33ebebcca05ed5d0a37e8610724107380e23d5d3219fc70322a7eb8b656b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb857ba1160df27d7dbb7692d3835aab9032d841a974444918660c766adfd0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb857ba1160df27d7dbb7692d3835aab9032d841a974444918660c766adfd0f4"
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