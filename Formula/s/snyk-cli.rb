require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1248.0.tgz"
  sha256 "d6ef317be1864fbd9728fe7e42e52ddaa6d959a9c0aa78d1245bcf5b5a04e2df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d7ac2b6877ad0ffc448bcc9bb1b7f89473462d830aa292eeeded0ed5752953d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "024fe15c402efe0ddb9d7d87389f8c3dbbc8b3538206b41486d2de5943ad798c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29ddc84c61671a2caa75281c099c0d31ad7140cee99084d4d87ad91a61015522"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d247223623b3c710e41962c701e38cbba139af0b995d16f4bd3d593bf692393"
    sha256 cellar: :any_skip_relocation, ventura:        "88c6feff36cd3d93416cf6dec15bfea17a8cd7d336d1a839894a29b68de9d677"
    sha256 cellar: :any_skip_relocation, monterey:       "1ebed566ccfd98c20d599a785efff12ef146c1412cf16259d25cb1624014d0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b419c6e5623f9579e32180a95f26385a84f518ae3f3f8afed74a1b5e94eef331"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end