class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https:skaffold.dev"
  url "https:github.comGoogleContainerToolsskaffold.git",
      tag:      "v2.14.2",
      revision: "d76dbabc8f951df21560ccf2063c1d04cef3b6f8"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolsskaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67d1c776f7db13a0dde3f0d1ee92826d06ae31e65097b79c3865390a85b6bed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c219866ce9ad4b864e724780c5d7380f08c142770b6d4af15e0a7af11ec0ecec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52cbc9e73a00b56a3e35c3ab4440cc225bff810d580b23b2b3e3341f0795f623"
    sha256 cellar: :any_skip_relocation, sonoma:        "01d54fef951a8ec92ff061f665258278c3caa085a814777c2fcd46ee22a5c345"
    sha256 cellar: :any_skip_relocation, ventura:       "23132f616a9027dc0457b14ca282054a91e0c4a78ac84c4888e00abc4d1f2a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c907f65ca01978cfdc90413bc7d3cad4d2ee653759f88c7d88594676c641b96"
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