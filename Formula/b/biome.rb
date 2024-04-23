class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.7.1.tar.gz"
  sha256 "5c0039542da12ebb3af87a193121563d428d5ed6551c4304309bcc9c781410b0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "379066313a9870efc9db7a883f416585a60a413d0ef19a34c21d1c94906c85de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "716a9c9a19dda3181c247a3d72f1b0ae32a7801228db8c1aed9f104786bdf43c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2290aa38720745d353eb88bbb29552f6154511d15e2624a5ce2366ccb5b8d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "86449ea9bbc25c44acdb4550ef06d991376168fcab904155b6f9e9371a2c3320"
    sha256 cellar: :any_skip_relocation, ventura:        "cf061cbe4b1119d490b1a3f9bb9f6b3caad2feca1333a300f2a3896dd045a82d"
    sha256 cellar: :any_skip_relocation, monterey:       "b34ff57ce1aee58ea279e5b01df7287676014cdff195e5fa68c7b9c306f512c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc95823d46f32294dfcfa568103178cb0249e17c1a6564dc4491cc7930d9a440"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cratesbiome_cli")
  end

  test do
    (testpath"test.js").write("const x = 1")
    system bin"biome", "format", "--semicolons=always", "--write", testpath"test.js"
    assert_match "const x = 1;", (testpath"test.js").read

    assert_match version.to_s, shell_output("#{bin}biome --version")
  end
end