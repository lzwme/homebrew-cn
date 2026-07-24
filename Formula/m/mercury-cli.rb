class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "8bc5460db261b437915282546346e5325f042470c0229f1781bdee3acf9de24b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c71d71b7f7120599e2c2a45f224ec991b5c5994eada8fae4e46b745626cde50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c71d71b7f7120599e2c2a45f224ec991b5c5994eada8fae4e46b745626cde50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c71d71b7f7120599e2c2a45f224ec991b5c5994eada8fae4e46b745626cde50"
    sha256 cellar: :any_skip_relocation, sonoma:        "5069b647b77d9bc6cfd954a067ce2fa6153216c92605714ba051c2f4c54f1aef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e192df59ab87163ff09c2ebbda53a9624002df4a4778f12a400dafb747171292"
    sha256 cellar: :any,                 x86_64_linux:  "496c2aa1ab977d88dfc95ada07e137aa416adbf60bc1e96dd2517ab3f1cc8cfb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end