class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https:helm.sh"
  url "https:github.comhelmhelm.git",
      tag:      "v3.18.2",
      revision: "04cad4610054e5d546aa5c5d9c1b1d5cf68ec1f8"
  license "Apache-2.0"
  head "https:github.comhelmhelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2839421ff115477637eb88afa346ba7108229013954aaed80d4a259bd28d7462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eb5a917a4862aad9c9b3a0773c1479ff58f315e1da7eb0821a8ab93cbc2ef45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26bafae2cc635414d9d73dbfb040099969280cd33147c888e3f5eb04ace75deb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcfdbfdb41d69f2dfac93b026e635b517826ed020aceae7ba46a98d608ddc6f2"
    sha256 cellar: :any_skip_relocation, ventura:       "dc2f2bf6003837227abec1d7cfdc02fe2609c241561650f1928e4a4059a52e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3987965b39c4e72f945704466af8003675e61995e5fdaceea7589000541e0f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3527cb26cf230591eba0e088038c9ec922e904f604899863fe3d17de08570b"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "binhelm"

    mkdir "man1" do
      system bin"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    generate_completions_from_executable(bin"helm", "completion")
  end

  test do
    system bin"helm", "create", "foo"
    assert File.directory? testpath"foocharts"

    version_output = shell_output("#{bin}helm version 2>&1")
    assert_match "GitCommit:\"#{stable.specs[:revision]}\"", version_output
    assert_match "Version:\"v#{version}\"", version_output
  end
end