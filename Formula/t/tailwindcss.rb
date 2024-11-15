class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.15.tar.gz"
  sha256 "a0e4b464917214f75353dd5bf4d3a5f5b7e60e3fda9f293c44a21b9f80013c8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51e76fd8a65db19a21bcf5ec76e784bd9b869e126d3ea0964a2b06f4e6a2b21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c51e76fd8a65db19a21bcf5ec76e784bd9b869e126d3ea0964a2b06f4e6a2b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7298a904009ee2bcfe2f1475586c18bce253f53002930354fddabb3fb5cb42c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cee64f596d8112f3245b13c282290243436c8f4862e816a38be7594da953f16f"
    sha256 cellar: :any_skip_relocation, ventura:       "e8ccaaa5719cf98e4141bcdfdf2dccc2d210a21de21281bac000a0ec3abc6bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edb4320e555f5d259028956495e191e50436e3808a86d2f33d9e9c754d3944b5"
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