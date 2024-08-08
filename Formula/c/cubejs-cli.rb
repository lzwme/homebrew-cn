class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.67.tgz"
  sha256 "5ee5630b42809d57b101ec080e5db4489de33a26a765067486641b02a6eb6d27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a1673b25c462e625aec0cb11b122ec57ac427e14dde0bb87b912837e11e0782e"
    sha256 cellar: :any,                 arm64_ventura:  "a1673b25c462e625aec0cb11b122ec57ac427e14dde0bb87b912837e11e0782e"
    sha256 cellar: :any,                 arm64_monterey: "a1673b25c462e625aec0cb11b122ec57ac427e14dde0bb87b912837e11e0782e"
    sha256 cellar: :any,                 sonoma:         "9c533f1f78f49e750472fde04bc0fee1dc803b24cbf0c9cb7cef69ee110ef66f"
    sha256 cellar: :any,                 ventura:        "9c533f1f78f49e750472fde04bc0fee1dc803b24cbf0c9cb7cef69ee110ef66f"
    sha256 cellar: :any,                 monterey:       "9c533f1f78f49e750472fde04bc0fee1dc803b24cbf0c9cb7cef69ee110ef66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed5173a08dccd4adbf90e9822a7a6eb22e1b86101c7bdafdece14197c1090996"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end