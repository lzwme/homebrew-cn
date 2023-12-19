require "languagenode"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.3.7.tar.gz"
  sha256 "995ed69acb96d0959c88839231b0c901914c606ef4f83ab7e96dce05743aa30a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9d9e84752243bbbb8153e35ac48ab9a155fed943d665b3a665a93be2a29d4df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aec6537054328981d8725a6d0ed6629132b3cafcee939752e7791be481ecd1e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aec6537054328981d8725a6d0ed6629132b3cafcee939752e7791be481ecd1e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f54d3fea6d370a05f34b3f0c50dda2c6f9fb724b807dd1f9d8d741920f4f95c"
    sha256 cellar: :any_skip_relocation, ventura:        "f0af22ee97d8850b7a8750743b697bc874435016db78d6bf3e8929ed2605223c"
    sha256 cellar: :any_skip_relocation, monterey:       "f0af22ee97d8850b7a8750743b697bc874435016db78d6bf3e8929ed2605223c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873647b74a8264b3f1ed1ca7f4dcc4ab9d5f37629d763abcac73a45145966be3"
  end

  depends_on "node" => :build

  def install
    node = Formula["node"].opt_bin"node"
    system node, ".scriptsswap-engines.js"

    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
      os = OS.mac? ? "macos" : "linux"
      cpu = Hardware::CPU.arm? ? "arm64" : "x64"
      bin.install "disttailwindcss-#{os}-#{cpu}" => "tailwindcss"
    end
  end

  test do
    (testpath"input.css").write("@tailwind base;")
    system bin"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_predicate testpath"output.css", :exist?
  end
end