class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.119.tgz"
  sha256 "f1e33089371085252eb36f84e9591b87cf09173716ad458f44158a05a20027b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34df49c8d2b6f30f2eae228a1b492bd3383a4e41d1716ecdcfe0af98ce89ff86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34df49c8d2b6f30f2eae228a1b492bd3383a4e41d1716ecdcfe0af98ce89ff86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34df49c8d2b6f30f2eae228a1b492bd3383a4e41d1716ecdcfe0af98ce89ff86"
    sha256 cellar: :any_skip_relocation, sonoma:        "26f52bc2cc26a0637a8da7b29b9ec497af0be8130be2bfda8a316c61e23b3b3c"
    sha256 cellar: :any_skip_relocation, ventura:       "26f52bc2cc26a0637a8da7b29b9ec497af0be8130be2bfda8a316c61e23b3b3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34df49c8d2b6f30f2eae228a1b492bd3383a4e41d1716ecdcfe0af98ce89ff86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34df49c8d2b6f30f2eae228a1b492bd3383a4e41d1716ecdcfe0af98ce89ff86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end