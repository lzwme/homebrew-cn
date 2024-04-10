require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.116.tgz"
  sha256 "0ddd3314ad76bb3f453f89df3dcb26a0baef74508d8a0df7986a34870372c7b5"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d254ae72ae648cfd97d81d0f293fedc834da06393f481a02dd7736c0af60e64f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d254ae72ae648cfd97d81d0f293fedc834da06393f481a02dd7736c0af60e64f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d254ae72ae648cfd97d81d0f293fedc834da06393f481a02dd7736c0af60e64f"
    sha256 cellar: :any_skip_relocation, sonoma:         "926a1866b3f05c0da56816b6acaaceaede75afdf658e4d65d1b124b472ab85cb"
    sha256 cellar: :any_skip_relocation, ventura:        "926a1866b3f05c0da56816b6acaaceaede75afdf658e4d65d1b124b472ab85cb"
    sha256 cellar: :any_skip_relocation, monterey:       "926a1866b3f05c0da56816b6acaaceaede75afdf658e4d65d1b124b472ab85cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d254ae72ae648cfd97d81d0f293fedc834da06393f481a02dd7736c0af60e64f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end