class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.8.tar.gz"
  sha256 "350c10d7a9517ef626a7f6a00c88846f4466b56ea13303dc0cf2c479d799d226"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e672f469673726a9f6f2787b3e79021a52c61913d1da44780692fe205a9e5ee5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5655c947a030cd5dd022350d01b6d5852dc0a4ae166fea341fef1aa18249cd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5655c947a030cd5dd022350d01b6d5852dc0a4ae166fea341fef1aa18249cd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c406626e88af23132dad6d91bea4d51fb6d907af0fc19853c7ea6800049e4a2d"
    sha256 cellar: :any_skip_relocation, ventura:        "b546d6af1169c8c1e0a8a7bc633116805c33309d1905eda69f62edeb2f877091"
    sha256 cellar: :any_skip_relocation, monterey:       "b546d6af1169c8c1e0a8a7bc633116805c33309d1905eda69f62edeb2f877091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973bab7ce21c446950f318e885ca7a7032e8b832336f6bfefea4b5ddd5e891d1"
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