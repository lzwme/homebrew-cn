class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.11.tar.gz"
  sha256 "f12744c4df34e82cee741cb0de47e34fb91d0a9203a5df4787e84e02fd6427d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a4aa877f4c990f4a63f2bbbc7c1b7efe4ac657a1cc805bc1bba955d5e4e38588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4aa877f4c990f4a63f2bbbc7c1b7efe4ac657a1cc805bc1bba955d5e4e38588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0322911a550c92f3a1223a369066262a87170a47504aaca7f906b3f7da2ab7b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0322911a550c92f3a1223a369066262a87170a47504aaca7f906b3f7da2ab7b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ed9160b80994f3962d6f708173da9a81835aeb898d30407f2d879103dcdc65f"
    sha256 cellar: :any_skip_relocation, ventura:        "ae41967ace82f9a9444d83d4385154b2ce5454db133768d0045893fd40a4c51f"
    sha256 cellar: :any_skip_relocation, monterey:       "ae41967ace82f9a9444d83d4385154b2ce5454db133768d0045893fd40a4c51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45910d7a4d31e59bf7281c1be725b456be76fe6e10381c44a4001b8e02081cbb"
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