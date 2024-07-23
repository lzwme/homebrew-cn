require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.5.0.tgz"
  sha256 "4f7f52cf9f3bc62ebc7ae60d2db5c7f896cb0915ad1202dab9285d6117d7536d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52938716a78abfbea7f2411345684025a55413025d04b05d0d3d5e4cbde689a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52938716a78abfbea7f2411345684025a55413025d04b05d0d3d5e4cbde689a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52938716a78abfbea7f2411345684025a55413025d04b05d0d3d5e4cbde689a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "72457d71db50dbf7b6d39177731bf52331f058dec02f9ccd79a52bdda134fdfc"
    sha256 cellar: :any_skip_relocation, ventura:        "72457d71db50dbf7b6d39177731bf52331f058dec02f9ccd79a52bdda134fdfc"
    sha256 cellar: :any_skip_relocation, monterey:       "72457d71db50dbf7b6d39177731bf52331f058dec02f9ccd79a52bdda134fdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9f4fe978157694ed1a9a4060ed52f9f4321426fb5ba91794b6fb6b63d01529"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~EOS
      {
        "name": "grunt-homebrew-test",
        "version": "1.0.0",
        "devDependencies": {
          "grunt": ">=0.4.0"
        }
      }
    EOS

    (testpath/"Gruntfile.js").write <<~EOS
      module.exports = function(grunt) {
        grunt.registerTask("default", "Write output to file.", function() {
          grunt.file.write("output.txt", "Success!");
        })
      };
    EOS

    system "npm", "install", *Language::Node.local_npm_install_args
    system bin/"grunt"
    assert_predicate testpath/"output.txt", :exist?, "output.txt was not generated"
  end
end