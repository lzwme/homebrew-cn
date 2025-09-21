class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.93.0.tgz"
  sha256 "2bc73a273eb6c78da43612039268323d0b9363d23b78360979b33f46fdb51b24"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0c7fc8e6adb34c5eefec58dacbc67b153d1a628e888a88c5143e26753f2a6137"
    sha256                               arm64_sequoia: "965cc546f286e3f439b88acc8426cb0d5e191399479a36cdd543ab847a8b7ecb"
    sha256                               arm64_sonoma:  "66fa2618e0646fa4b4701fe8d213f9e84aa0549e0819707bbfbaa394423d4341"
    sha256                               sonoma:        "c016972fda6aec134d29e96faf81d8260392f7e40db3e5d2b5d8c248c27aad9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e9ecb1aa537ab48401ecd2ccabe5a373cd9bdb2d68c9c30a5983caa1e72c96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0437107f33198ef14352bfb51515c0c49970044debe045941c6496ab5f935d93"
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