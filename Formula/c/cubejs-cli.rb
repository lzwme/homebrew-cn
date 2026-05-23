class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.49.tgz"
  sha256 "eec481a72a341f268c2abc50f7898fcb939eddf29e0118221573c825e070a156"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8fc4488c4f056cdf8c4bd5707be86f4f947059409802c2b533aaee3d7f35140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8697650b368d4f1c8e4b3f5f41c6a2232a076c42e785755df3f9c5047c668e4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8697650b368d4f1c8e4b3f5f41c6a2232a076c42e785755df3f9c5047c668e4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8634c9291e650d6093d3d96ee1b848bff76b800b6f2c76ebf340f5471d2c826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18ef7abc722596c6ee35548ab1e6ea5dedcefd9523d0b45621dd9d2becfd123f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ef7abc722596c6ee35548ab1e6ea5dedcefd9523d0b45621dd9d2becfd123f"
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