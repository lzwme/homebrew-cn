class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://ghfast.top/https://github.com/stefanprodan/timoni/releases/download/v0.31.0/timoni_0.31.0_source_code.tar.gz"
  sha256 "550ef8f06ac153ab355506301ce764cf07dace697fa410773471ac26a1cecb81"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c61a8337c679341267a564c831b3f3369fee6700f00097d4f45628d23227a93b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "801eac96e3677f1e3e1e6094fdd30510ab4fca487a34ba57aae016314755ff23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7929b1fe2f6e02a4abcf6834d2aa36046bac7ac82c41925694c6084290d494e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f29ded762cd0a0f851583a5046ff1325b77c768bbdb45ea2a3752694a036a83e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83e7a0ff090a57d6ee6c40dca363958e457f19ab7bdbc2ffdf002c5e396ff820"
    sha256 cellar: :any,                 x86_64_linux:  "57fe28da826b1023ba523b520a847ac37cc00ed767a55b2073e2599b096db675"
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