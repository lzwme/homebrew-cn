class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://ghfast.top/https://github.com/git-pkgs/brief/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "481175bba6e76e7993ff47178ab8923c05323adde79442673d61c2d5d5f5fc86"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49923598ffb40764fd03d2a5167df8bdbe5bb03d92867e801ea322024e72bd95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49923598ffb40764fd03d2a5167df8bdbe5bb03d92867e801ea322024e72bd95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49923598ffb40764fd03d2a5167df8bdbe5bb03d92867e801ea322024e72bd95"
    sha256 cellar: :any_skip_relocation, sonoma:        "9131aa477f365e758610a64f29e6058c6be1a933f73ae4600323ee1e7b4d6cd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9152485aec55b8d6198f4710807b6fe80a691f0a7ce963b97e462071762399d"
    sha256 cellar: :any,                 x86_64_linux:  "62bc7925bc163612382cfeb1d25d34fef7600c52f37b24b816e325ceee3260dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end