class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.9.2.tar.gz"
  sha256 "110d03618211a1a5d0bc7f9c31f2e948108a11a0ee22d2f07ddb8e944efeaa05"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c07bde709345f7aa485824b0704e10ebeb8bdfda37a1c4a97fd31a656833a582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "827ca3ef28b3680fcda172bb82075d89dde71952d834b6d0b96f17bb5f077b29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0244659442d3ba2e5af331422f9a4af7d223066e18fb87e8d204163a6200483"
    sha256 cellar: :any_skip_relocation, sonoma:        "75a80b753846f457d4129a9f5d54511a2dd625a1387c1d8152759f1717a785e4"
    sha256 cellar: :any_skip_relocation, ventura:       "291c56e7432c59b71c0e94fd66a02146614cf8c013473c8543c48b37506fd85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a21ebde97aa62dde84320e3c4d5167a8058f0fa2a5108ae2be2512f565cc489"
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