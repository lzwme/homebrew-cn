class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-18.1.0.tgz"
  sha256 "9e5869ec903ed85e40f1cbc732c3f65908bc4bc731e31df76904b77a04bf073c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6494c9a0151177e63f258ed0544c09a7e09897c5674be26457eae3a17d79df6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e51c28678e5f954938289723ff22f064c43f88f544c47487b04059bfdea4a2eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51c28678e5f954938289723ff22f064c43f88f544c47487b04059bfdea4a2eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "967a593ddf0c5330977bd817f6d81542811077a12520249f0a95f353e6863b62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "705fb22a2a7af50eaa620c13136d429a61136327985eab24ac0bc76ed63fa0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "705fb22a2a7af50eaa620c13136d429a61136327985eab24ac0bc76ed63fa0cb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end