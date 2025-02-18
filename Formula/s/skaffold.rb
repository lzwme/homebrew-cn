class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https:skaffold.dev"
  url "https:github.comGoogleContainerToolsskaffold.git",
      tag:      "v2.14.1",
      revision: "62fba6a236833db0d0d689a33e0b1007518d3456"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolsskaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d5b361bc90efc29ceae8ba7c694521178a2fd8aa7be1da08fdfd2f69c2063e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5fffb1fc3d8a5e16c0cac50a3ecb29188ba269e04c6e706b91b232f0defcce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b85b38c9b9f60f8c298e6f2e0a1d95e663d938c1772834899222e1f3bd392da3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc40e671f55369abf4de8cbdfdd7e45c75fba1aefc5bc59d0538e25528d46cbf"
    sha256 cellar: :any_skip_relocation, ventura:       "9352a00bc31126e10dfce13f81c2e076ae85822e4fdf2ce2dbfe3a8c1db1e8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ae54f6b378df57838c5058a2dc05a9b9b6cac8456539fa54e981b2c903f0a5"
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