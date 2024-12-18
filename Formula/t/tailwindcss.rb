class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.17.tar.gz"
  sha256 "89c0a7027449cbe564f8722e84108f7bfa0224b5d9289c47cc967ffef8e1b016"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef1e89aab19737e3c66462f57f0f61267e4ed4fdd9967df8f41b37ef66db56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef1e89aab19737e3c66462f57f0f61267e4ed4fdd9967df8f41b37ef66db56a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a0a4bcb9fc57504bc217357eb758034d900b5b2040198f1d65153ccbeade325"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c15b605c267dd61402165f81113bcf07296d6941ef8b574c9b039154fff9651"
    sha256 cellar: :any_skip_relocation, ventura:       "879e7436c37cb8f65c418009e85216707354285730be1078795405d8ce9dac56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "646671381a5cbb0a2231f3a40021fbc2790311303f5c131d0d844ef892104ca2"
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