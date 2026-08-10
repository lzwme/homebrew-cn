class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://ghfast.top/https://github.com/stefanprodan/timoni/releases/download/v0.30.0/timoni_0.30.0_source_code.tar.gz"
  sha256 "8c1168232adc43adc211c8eb0009a463bf92dee486566e2a654946da46af9d1e"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644da68c39ff2e595d7c98cc1e952ba00c631bc89ae95b48b674feaf9e366947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78cfd7135dad37ce8b1a3ffea54cad4ed29caa3a9418ee3fa4442fd676120e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec0ac9c888368dc14e29a712b0d68a4954e713be3b9a14f62136928c5d1ef66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce6246546fc4c8d44ff8202811bddc6afc97376189691d2c138a5ee3ced6a02e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1bcc2ee4685b770bbd69eef59df0ea2aa2b906ecb305bcc286b6f4816d58dd4"
    sha256 cellar: :any,                 x86_64_linux:  "36925a6476ba3cbd8a5ea04b42d137decf730ea91fb9b1a51afba79737549a32"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end