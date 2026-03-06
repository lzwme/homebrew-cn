class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.17.3",
      revision: "ea3e6428d6b97154a0c75dca11b7d4cd14aa05a6"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0b00d5daf5c2c772877aec094fa15727db67dc928778fe232145366e9ff1033"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ded57bf649624bd5224eaf5019e6d97c0e46fe1ca17e279d387b62d34e3ad0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d99c51889a6a0558d13d13eada143b9df8c7657551ef6faa0144ebbf9349e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "addf12aeeb3682a39b438d52c77b80219ce43faff6b9983ee53e3802d41b6727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6d9d2eaa7e653d0a11233354724d755e049831d6e264111d96e78f5d54281f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bff4c161f25bbd5405335a0451cf9b447c194a4f1b0a8a15fa2c72b331f7f40"
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