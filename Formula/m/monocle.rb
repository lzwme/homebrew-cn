class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https:github.combgpkitmonocle"
  url "https:github.combgpkitmonoclearchiverefstagsv0.7.1.tar.gz"
  sha256 "27b7021b3b25102972b35e7d6beed4ddef971a45053da5811b9929d6c48b8e6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d69a2855e16951f555a56eecd549c5c1581ab746b72a2e6191907ab4c5cfc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f34150ad6b9cafc6a928e66a43871090a2fc7a2dd9d1f8768eeda73ab11eafaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fefbb2eecc3ee6f164c95b58b74add3721564f13a71fe348944a68b4831a27b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f5c07bafb2c4b1095a6286bdeaa86f8da5f65b75741ef6d93bbed0bef4544b6"
    sha256 cellar: :any_skip_relocation, ventura:       "e8311b37ae40af8b53928daac1456261f1e82e085e7871ca0e6212d2e08d46da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3392ce4f1ce041fd54ba4882c61b30927ac5a417f0a9310712302b94f7ed6aae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end