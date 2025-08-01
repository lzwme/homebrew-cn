class Charge < Formula
  desc "Opinionated, zero-config static site generator"
  homepage "https://charge.js.org"
  url "https://registry.npmjs.org/@static/charge/-/charge-1.7.0.tgz"
  sha256 "477e6eb2a5d99854b4640017d85ee5f4ea09431a2ff046113047764f64d21ab5"
  license "MIT"
  head "https://github.com/brandonweiss/charge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f26cdaf761fc50ccd7782b3cc3912d0a8dc93e0acf0bc24da2c7d842ceea4121"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83bf10a43c6321be09aecf20dcc0c80daa76f96847840edef4964eea9fcac492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed6f9833cb67b677f2131e681ec50ceccdb95261bbeb071a64c301c4800e7bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfacd98af0f9c2293eef24cb7610a5d2cf60ff237cf790b1ad5ff6cad018a855"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5b8e71865af91b528a3e46a4bc8457b26c5e760b62c0b9ed208dfede79d769c"
    sha256 cellar: :any_skip_relocation, ventura:        "f480ebb1cf027fe833c46835e13ce69ee6488138bfdc7df66a9bba3dbce3ec88"
    sha256 cellar: :any_skip_relocation, monterey:       "686efa2b941ac91dfd02a60df15223b3b887b791a2226ea4cd6fbeff9287f912"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d23d1330af8394dc65fd857829da237d45ffabe57f2e59019f0564a0b2c7d95"
    sha256 cellar: :any_skip_relocation, catalina:       "b6b02c7658ca9d8c8211554a74d399f5a9188f516e152fb7eee5a2b879d050d3"
    sha256 cellar: :any_skip_relocation, mojave:         "f2d73159f3331a3c7a6126eb7054fb987abf89598521fad3dece201f06cbf79d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2dcccfe026217c62a72db3ff501ee56c1c8216e5f00e567ca12706aaddb6ea8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "624762292729f409a6f737af99495aff8c24340d4b9b6e93c8e155dfa12cff6e"
  end

  # Does not work with supported Node versions
  # Last release on 2020-03-12
  disable! date: "2024-09-09", because: :unmaintained

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    (testpath/"src/index.html.jsx").write <<~JS
      import Component from "./component.html.jsx"

      export default () => {
        return <Component message="Hello!" />
      }
    JS

    (testpath/"src/component.html.jsx").write <<~JS
      export default (props) => {
        return <p>{props.message}</p>
      }
    JS

    system bin/"charge", "build", "src", "out"
    assert_path_exists testpath/"out/index.html"
  end
end