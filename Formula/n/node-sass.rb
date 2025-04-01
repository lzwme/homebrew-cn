class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.86.1.tgz"
  sha256 "108c14ea9a5c7f054553a2401079b9af5fd37bcb7d6ac8908f2c609e47dee849"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "bb0b2848e87a2d341a6b2582bdba7ae10523b77f9cd4b26dbfec26f449b873f5"
    sha256                               arm64_sonoma:  "2e4a36eac9ee1abd2a398556fc71140d1d05d7211913220255463392ca03ba6a"
    sha256                               arm64_ventura: "af222fa6d97a49a1d05f8dc7b3115158a02cc6a9b9b2475a2ea84dc174c5f818"
    sha256                               sonoma:        "5984174573eb3b9f6e5da5935a5b49e7e42c730d6abb1c2399081ed601faf395"
    sha256                               ventura:       "96b004b0bdb18c3214192e6d3df806e24c6ae6c8c0259688e8875d180208766d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001d0c280305ab15b142362100056ebaf929cde258e78003e3ff436adc5eaafa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5fd1e104acad05b12752b50fe1a14cbe5d00495d36c6eaf93f88edbf6618cf0"
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