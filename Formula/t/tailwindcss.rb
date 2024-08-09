class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.9.tar.gz"
  sha256 "41421c59cd274999a083cc618300a53572a2de7e93bc32f7d6663f1c5c02acc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "196257c0ea44b076b71c9501801331f9143149f6b7b5be53de9b5a76c14f2571"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eaf2107ccd4b874c6fdc9eb5f59235d4afcb5849c66ea971d31b514daa2bf2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eaf2107ccd4b874c6fdc9eb5f59235d4afcb5849c66ea971d31b514daa2bf2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9df545b831278d8412229d33a4ca7fa1b17b42f8ed9c7f62268f3e398aa18687"
    sha256 cellar: :any_skip_relocation, ventura:        "4b30a7b4b2eb468ac81d351962c9c13b7acace8364a1c88d85e42b3f55a52fcd"
    sha256 cellar: :any_skip_relocation, monterey:       "4b30a7b4b2eb468ac81d351962c9c13b7acace8364a1c88d85e42b3f55a52fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe203f13429e084b6d3d6bc4df6a32518da2fcd17f8f5eb8e725b836438f8f1"
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *std_npm_args(prefix: false)
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