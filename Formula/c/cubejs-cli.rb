class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.7.17.tgz"
  sha256 "ede4486367289c34e24c7f7d7828d5f6714ec2918e024ed02017d4c6383f858e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eba25109a4fccc09ec941f244b6847ee8f40eb28d47eaf7f675fa2fed20d38b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eba25109a4fccc09ec941f244b6847ee8f40eb28d47eaf7f675fa2fed20d38b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eba25109a4fccc09ec941f244b6847ee8f40eb28d47eaf7f675fa2fed20d38b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7e7a278118550996139f1922c362becb83bef59402ee81fb330c9dcec2cdb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b19e96d901f7c275e9c8c4bfa0453ef0e11cb6e3cc9e51a7c688b4619f473ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19e96d901f7c275e9c8c4bfa0453ef0e11cb6e3cc9e51a7c688b4619f473ba8"
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