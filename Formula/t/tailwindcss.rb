require "languagenode"

class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.1.tar.gz"
  sha256 "a3f5a288d8d0b2b9b9dbe0448fb325247fd71a758c6b645f76a93c3a4ab510fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07592ca984c58d3f7ec0f8d24822e056dcfc7887daa36df863df71e03139363b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c267905b8fb5ba2091410c363badc8b383da42632c280eb0a998d12fc7d8ca3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c267905b8fb5ba2091410c363badc8b383da42632c280eb0a998d12fc7d8ca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cd717bf09834489527c774529ee81f17b9ea4551a57c0813273fa368a28a487"
    sha256 cellar: :any_skip_relocation, ventura:        "4cd1733c1a6f29b38a662bf55b9ce4cbda15fbdb86ceb5ba84f7558e2c9efe46"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd1733c1a6f29b38a662bf55b9ce4cbda15fbdb86ceb5ba84f7558e2c9efe46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f81bfd58ab4836f971a419febe29a46b1e83dbb79f1b357e6196b80f20549f"
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