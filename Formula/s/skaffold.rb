class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.22.0",
      revision: "f9beeb7b68778673806c5e9a3b5748af916116cd"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f714124bb69d81149587fa08f842200e24adee318fcda192f447acfd823f9c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62875716559f3b9014d3b78801c873be730694327149e2407bac70c97a64c807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c7d462204004eec5d8d2a159f460e7a12624794106fe088ac8a60d4591ad096"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8a9c0551d81c4698fcda90c15e09d0d2e47a3da0c3b6da877eb3417f63ba6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "612ed47f3d0911a5ad950c79ca98a89463018725a36595a0889f11aa623df849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddf01a571344267be7b0def04ca22bd5fc2283900d611e370fc4a5838c246fe5"
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