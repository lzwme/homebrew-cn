class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.5.tgz"
  sha256 "fb60ea78083749eb37934faecba877370aec2793a197d18a3e3486457d236e40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93e35946bc0b230272eab8760d014f6af4eca09a4356d9a91c759f7ebcd8a8d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93e35946bc0b230272eab8760d014f6af4eca09a4356d9a91c759f7ebcd8a8d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e35946bc0b230272eab8760d014f6af4eca09a4356d9a91c759f7ebcd8a8d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "93e35946bc0b230272eab8760d014f6af4eca09a4356d9a91c759f7ebcd8a8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "93e35946bc0b230272eab8760d014f6af4eca09a4356d9a91c759f7ebcd8a8d7"
    sha256 cellar: :any_skip_relocation, monterey:       "93e35946bc0b230272eab8760d014f6af4eca09a4356d9a91c759f7ebcd8a8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf217e3d6ecd47328b11fa22aa2cf43de1dbf7d6c9845850317b22cdbfea953c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end