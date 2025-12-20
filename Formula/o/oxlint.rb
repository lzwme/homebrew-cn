class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.34.0.tgz"
  sha256 "3b5dc380c1ca531fdcfd67f3a1b1daa87ab7ad65974bc123e7cb89269e26b3ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cced1f3729426e39b83add683659430ec271102c45626b4d6e57719e99f407d"
    sha256 cellar: :any,                 arm64_sequoia: "d926f8f33adae7a60db495b96d5ac700a05e7dea85a36dd90bab7d1285a5aa75"
    sha256 cellar: :any,                 arm64_sonoma:  "d926f8f33adae7a60db495b96d5ac700a05e7dea85a36dd90bab7d1285a5aa75"
    sha256 cellar: :any,                 sonoma:        "5f49325376554a34beb4790d40062df79653d729197538fb65ac3b9e73b70c28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc7e3b13fa156a4c38e13724604a726776ca3a44e8b71ea2858a96d9e258c1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb9d991a7f65a2d42e391b45726f95e50bef472a3ee657908946879678911350"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end