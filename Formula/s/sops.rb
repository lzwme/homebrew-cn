class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://getsops.io/"
  url "https://ghfast.top/https://github.com/getsops/sops/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "70f5b1ba589cfe509533b0ae888c75bdca2e49f2e79cbf22a21984d154368f4d"
  license "MPL-2.0"
  head "https://github.com/getsops/sops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "443b98cdbb0768e1cd7b03c8dcee47ca8d70eb7f25277c7fd5174837f465c5b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "443b98cdbb0768e1cd7b03c8dcee47ca8d70eb7f25277c7fd5174837f465c5b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443b98cdbb0768e1cd7b03c8dcee47ca8d70eb7f25277c7fd5174837f465c5b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "39d664def6c4a59536572b750a0daf420d9eacfaaf4dc4243d143383a083afa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58bcb13c9fccc7833ce6236a4e5eb57a06662943a84a5ee03cac92d478f97109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5388ba547c927e95f42b513fc6107a9583d16f886a8b629a5a17db221021e377"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end