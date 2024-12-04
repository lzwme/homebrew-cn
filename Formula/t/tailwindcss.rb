class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https:tailwindcss.com"
  url "https:github.comtailwindlabstailwindcssarchiverefstagsv3.4.16.tar.gz"
  sha256 "8fa36dd87174cf50e34727901e31e17898c15cc838e8e7c98d5a6d603a86ae41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96738753df2a90f5c0176feb038dfc9b5b00dfcfa6b4c432ed28acfc980386bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96738753df2a90f5c0176feb038dfc9b5b00dfcfa6b4c432ed28acfc980386bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a0c9f3fc992bbbe1a2033df2218235eed6cf86ee2a095c3b8597c1047999208"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a10e84e77a157ae6b854ed17143c706015825ec18aa3135073143cead29dd5"
    sha256 cellar: :any_skip_relocation, ventura:       "bed35f6e59f6aa800377069ecdbeabea9cf75957c19632b49c0b958cf20dc7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640015dc5d5931e2315cfe730994dfe73e64f0853f188a6aea48421ef5ff735a"
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