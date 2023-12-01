require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.18.tgz"
  sha256 "50fe0619b3e979834b501f4f1458f97e10bb8e3fa8de50b575e283eeed8e35cb"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24296a9c948c34698de6443e5f6f899238f823c060c6c80cba3a0bbfa7dedb21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24296a9c948c34698de6443e5f6f899238f823c060c6c80cba3a0bbfa7dedb21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24296a9c948c34698de6443e5f6f899238f823c060c6c80cba3a0bbfa7dedb21"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed460b2286a799fe85cd856d4c70a8d4fbe0582d807e29013f78396fa8b93d2b"
    sha256 cellar: :any_skip_relocation, ventura:        "ed460b2286a799fe85cd856d4c70a8d4fbe0582d807e29013f78396fa8b93d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "ed460b2286a799fe85cd856d4c70a8d4fbe0582d807e29013f78396fa8b93d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24296a9c948c34698de6443e5f6f899238f823c060c6c80cba3a0bbfa7dedb21"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end