class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.14.3",
      revision: "62ab2b67d9b32d1be7336b6e3300602d4994883d"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b40337bbaa341f6b1e9b9634fec7d72520380c166d31eac47fabb2e8b5771c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59ed7854cc491ddd603ab7b61d79ab753eea4df865fda9aa89d8158b52e46465"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4164e41c12feba71c00d86da45ceaa498402df85ddd84ca6b7073b7a8758a174"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d1139045c8ded3d31eee89d2a251930ab0fcaf0332dd1e5ebd6303ebd4c2c67"
    sha256 cellar: :any_skip_relocation, ventura:       "361b2d25efd32dcefea0a11aef01a6744137c18e2fe1070020c2ed0e8b9de0a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca75baaf01ad232fbf57621f626cbb0107cf4485ff5f383dceb3b995f7897a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9b3e06cf2e9b1eba6977f55d9b3bab6715fa1ed9182859af81ec87e1cc203a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end