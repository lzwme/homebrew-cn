class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.83.1.tgz"
  sha256 "487c54e217c7a0948d634590e81288c2883547647cb6cb083fc3b99617301bbb"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "9d13f36e56028f0500f182dd6156af2321f27691cf19cabf00999af9603b9ec0"
    sha256                               arm64_sonoma:  "f6bf5c31811320078a7ff91d04e6edf6be87eb0d8a8037cc11b5b0215273712e"
    sha256                               arm64_ventura: "99f379008178b537671ede0de35cc04654d1fe04e27f8f78b084eb44466b1a79"
    sha256                               sonoma:        "b95d2329300a6cc02af3544abd6e68b915a6c611175a3123ed48588672c5cbf2"
    sha256                               ventura:       "5caf3ef316ce07899d41e016a7226a976577c8dae6d1f2d086392382ce98c7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f4197df23a0d0ff3d4f27a07954fde705c2fb9ef8b41ee72be1433a0b92ba96"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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