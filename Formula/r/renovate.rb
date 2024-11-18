class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.19.0.tgz"
  sha256 "0919736d8472548ee522e86632da3381fada77c55c759e7329912d4900355792"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29548e855ca1bbc237f72a8c4dd47ef44f49b9a5cb44ebcf614f7cfd53d35d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a5be1af490a6647fb4391c0d6c240d5b3466a2b6342b1e853ec0120d0f20c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fce807d0b8a98a324628c565b9d499fba184f39abfb0ed3ed171cd6a4ee5b458"
    sha256 cellar: :any_skip_relocation, sonoma:        "58a0f0ecc88daee92f9cc9d66ac84658216f7128087b994daa5cd37c26e57503"
    sha256 cellar: :any_skip_relocation, ventura:       "fe5ea4d19f7fe2a5caee830e8ce945841c948f6e4f3df8f4f3a7cadf3aaadc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7785a0a572137bddb74268371f802dfe1e15694c9e8fbdcfda4bfe21531d9d04"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end