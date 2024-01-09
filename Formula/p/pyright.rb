require "languagenode"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https:github.commicrosoftpyright"
  url "https:registry.npmjs.orgpyright-pyright-1.1.345.tgz"
  sha256 "dae68a8441532b4256ec84574dae9efddd96c8b37fa6394bb7a73126e1bec998"
  license "MIT"
  head "https:github.commicrosoftpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbdcdf0d636dd7d537ca82af5fac16a23245bc871cf17bbe4a49520f180e45e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbdcdf0d636dd7d537ca82af5fac16a23245bc871cf17bbe4a49520f180e45e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbdcdf0d636dd7d537ca82af5fac16a23245bc871cf17bbe4a49520f180e45e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b00d952160139d4ade2d6970904fbeac1f866d59ec59863c6b1dd18a45d4cda3"
    sha256 cellar: :any_skip_relocation, ventura:        "b00d952160139d4ade2d6970904fbeac1f866d59ec59863c6b1dd18a45d4cda3"
    sha256 cellar: :any_skip_relocation, monterey:       "b00d952160139d4ade2d6970904fbeac1f866d59ec59863c6b1dd18a45d4cda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "183bb65ef23ee8e780658bdaffe4829da27b1ad6a16f9e2b058302e51c8a4d77"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end