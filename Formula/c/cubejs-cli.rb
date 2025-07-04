class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.33.tgz"
  sha256 "bc26b5a93d99a458f9231a73366e542fdd9661953414847597bb1809a4a2d614"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f61b99e4191b3c682eaa63696d355e8f489969019f675dff04f4d06790897f9"
    sha256 cellar: :any,                 arm64_sonoma:  "0f61b99e4191b3c682eaa63696d355e8f489969019f675dff04f4d06790897f9"
    sha256 cellar: :any,                 arm64_ventura: "0f61b99e4191b3c682eaa63696d355e8f489969019f675dff04f4d06790897f9"
    sha256 cellar: :any,                 sonoma:        "d1b9be4508f347382c28179327b015fa42ccd395f636bd9e82ef75093875f796"
    sha256 cellar: :any,                 ventura:       "d1b9be4508f347382c28179327b015fa42ccd395f636bd9e82ef75093875f796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab407506c9ad704f8ecd26a64bcb0eac3c6bf6ae0147c27715b261afafd006cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c165dcfc206b0872a43faa47aea64a7158a51706f5e78d303e124b17302e695"
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
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end