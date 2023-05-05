class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.4.0",
      revision: "8f9209c755b4b2a041e564c7f98c723f868c0e80"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "407672116faf19ae667eff9ff1b5ad245ca43dd01b196976ca7888831930120a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89926ea4b7bf84638c0d5799ac9b9508b39b095551de393f4d45f7013de10725"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "169a324423f997707663c5c5bff581a261b564b1a9fb33d7c9dda8b367dc12d2"
    sha256 cellar: :any_skip_relocation, ventura:        "2e5b377a30c0cae896021d9e5721a30a258a3a3102d89e16ceb0798f6be1564a"
    sha256 cellar: :any_skip_relocation, monterey:       "83a556b63b66ad5b2df885355f77304cebc356068e65e1231c6f4ff0f27532d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc7f3df9d901eb7956f6313ee0e37b27b2fd6164faedde14fed1878e7a7bc5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3846c670ab6ef418bafca05b9af8ea132c3a1eb474982b7e6af5295e86890fb7"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end