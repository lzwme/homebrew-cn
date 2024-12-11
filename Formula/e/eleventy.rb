class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https:www.11ty.dev"
  url "https:registry.npmjs.org@11tyeleventy-eleventy-3.0.0.tgz"
  sha256 "821cd03bbaecf7dd657db6d20e3373e62fc30d78c44828b1334672294f924ec1"
  license "MIT"
  head "https:github.com11tyeleventy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "402360f36070efe864dfb0667e28d74500204bbf9bb355f119d0b4fe53b6585e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402360f36070efe864dfb0667e28d74500204bbf9bb355f119d0b4fe53b6585e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "402360f36070efe864dfb0667e28d74500204bbf9bb355f119d0b4fe53b6585e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b66c70dea8df5e3fac4f1801024d57dc533df2d12bdf016983527f12c18700a2"
    sha256 cellar: :any_skip_relocation, ventura:       "b66c70dea8df5e3fac4f1801024d57dc533df2d12bdf016983527f12c18700a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "402360f36070efe864dfb0667e28d74500204bbf9bb355f119d0b4fe53b6585e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin"eleventy"
    assert_equal "<h1>Hello from Homebrew<h1>\n<p>This is a test.<p>\n",
                 (testpath"_siteREADMEindex.html").read
  end
end