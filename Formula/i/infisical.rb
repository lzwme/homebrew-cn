class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.5.tar.gz"
  sha256 "995130d12a8ecffc5bb82e8efddc5b67584cd8b563952a5d0c23cd546556561f"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3919cb27cce611e7afd4e598819497616568bc72574a3bb716f4afa7efeb6312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3919cb27cce611e7afd4e598819497616568bc72574a3bb716f4afa7efeb6312"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3919cb27cce611e7afd4e598819497616568bc72574a3bb716f4afa7efeb6312"
    sha256 cellar: :any_skip_relocation, sonoma:        "de1593f1e35c1e2dc794e0ccbbe7191cdbacd1e9f21a76dd6882cfd1c6d690e8"
    sha256 cellar: :any_skip_relocation, ventura:       "de1593f1e35c1e2dc794e0ccbbe7191cdbacd1e9f21a76dd6882cfd1c6d690e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9bd3d0e0ea36d710a66db31c26044b567769979e1370c289b533a4c81910479"
  end

  depends_on "go"

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end