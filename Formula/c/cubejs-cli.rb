class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.15.tgz"
  sha256 "eda00fcc0050010b048c5ea0701d2f370dacb26d132bb7b4cda4b2440fcf0891"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58c91a9aad990d23bdffef38ef5d331b5651c65fe123e8b45be41f04e97bdefa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc3d0168ebf18f5c712cff4468c0ce80cf0bd0fa48ede31afaae1c71560948d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc3d0168ebf18f5c712cff4468c0ce80cf0bd0fa48ede31afaae1c71560948d"
    sha256 cellar: :any_skip_relocation, sonoma:        "56864e1b4bcfc05aec65181c90f5d6dbb63a40c3f3edb8cfe5a9e8afce25e956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed5ed8b3787d2f99700246bf97a457d9e49e39c49c37178035cc541258cc2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bed5ed8b3787d2f99700246bf97a457d9e49e39c49c37178035cc541258cc2ce"
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