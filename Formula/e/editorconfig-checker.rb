class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https:github.comeditorconfig-checkereditorconfig-checker"
  url "https:github.comeditorconfig-checkereditorconfig-checkerarchiverefstagsv3.1.1.tar.gz"
  sha256 "d6de48e949d11382bcdab68e76f6ea5e63bfc113f0132a8a888de4faf3bff569"
  license "MIT"
  head "https:github.comeditorconfig-checkereditorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d66db41743d07ee4b1b98cb900556c9ec9042513a698459b790a7456dac29ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d66db41743d07ee4b1b98cb900556c9ec9042513a698459b790a7456dac29ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d66db41743d07ee4b1b98cb900556c9ec9042513a698459b790a7456dac29ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e5668e045aaa59e92861edefc54ffd69743d412101ffd278a1b3ff96dc0ed8"
    sha256 cellar: :any_skip_relocation, ventura:       "38e5668e045aaa59e92861edefc54ffd69743d412101ffd278a1b3ff96dc0ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2051f75f96c38dabc75a4c528a70b762103332c7a01c2448aaf79894756a5a5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdeditorconfig-checkermain.go"
  end

  test do
    (testpath"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin"editorconfig-checker", testpath"version.txt"

    assert_match version.to_s, shell_output("#{bin}editorconfig-checker --version")
  end
end