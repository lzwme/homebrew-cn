class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.9.tgz"
  sha256 "6d3cdf44ca388d2e8cdc7b11d7a98f9fa9f319be43083736c1abb5f7b2931724"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46f505ab65001cfcf083e8e8b9370929e3e733a78d629c0835e951597210b9d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf6095b7a0997639d15acb78fb55d65ae1006ed8a61f8643a810245904061f77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6095b7a0997639d15acb78fb55d65ae1006ed8a61f8643a810245904061f77"
    sha256 cellar: :any_skip_relocation, sonoma:        "da9a44df2621d5bb9bcc575197134f5e0947d50e441259cdfd3b05bacdf40335"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac9c1a3d102af3babb2d7eb53bd85cfc85ece56edbee1d1537aef80f89d3c704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac9c1a3d102af3babb2d7eb53bd85cfc85ece56edbee1d1537aef80f89d3c704"
  end

  depends_on "node"
  uses_from_macos "zlib"

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