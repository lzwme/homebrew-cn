class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https:skaffold.dev"
  url "https:github.comGoogleContainerToolsskaffold.git",
      tag:      "v2.13.0",
      revision: "7f817f3e065287292e7e216862fc4460be192ac9"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolsskaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad63daf5c611c8f03fbc69f21d95a19ae0dd34358d4f34b78561123bafd68947"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7512e4d76103d0fe5400dec192aaaa5d9b578820d3df7025899ea3de0c78b24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27b6800a982fd5b67d2ce768c9bd34f186a02142254adb2eeb0050ab43e9ddb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "36647eafa9e70578b56997c4b77ad8f772f524408fdb8e3fd688c5a198c98097"
    sha256 cellar: :any_skip_relocation, ventura:        "939083bdad6c2f2c2440859c84f7259952a2d43896fa3cc5ba15556c4d76dedf"
    sha256 cellar: :any_skip_relocation, monterey:       "d7ce9185fc35844a7d049d5b1bc254f4a6cddf766e0234f6d22f9bf0bd142a4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa2c5b21a67680a9dccda19980bf7edf6196681f74555c389ac5cbd43d09eac"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "outskaffold"
    generate_completions_from_executable(bin"skaffold", "completion")
  end

  test do
    (testpath"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end