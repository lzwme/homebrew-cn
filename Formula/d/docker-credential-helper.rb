class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://ghfast.top/https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "547d0cb12c15faedced31487e6a456c63c0faa6e53895da076619733ef8917eb"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f20050cbaf3fac6d52d9d22e7dc2621873fa1eab4e71541e92773a76d50b1dc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81783a9bed56d5bf3ce53160a4cb2acbd5736a25e9371ff00f77e73f0414d3d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "581b2ab8f7f96480cb62681a2756091de64902cee65eb20af9c2821b4cd8a081"
    sha256 cellar: :any,                 arm64_linux:       "32a6a04e503d070f4ceebff3c495a44d3c1b7d0c6c966e28f82898a699ed751e"
    sha256 cellar: :any,                 x86_64_linux:      "3a648edb18b72f64669a31c0c48d4028e3468ef46c105117f43cdbadcc79c50f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    if OS.mac?
      system "make", "osxkeychain"
      bin.install "bin/build/docker-credential-osxkeychain"
    else
      system "make", "secretservice"
      bin.install "bin/build/docker-credential-secretservice"
    end
    system "make", "pass"
    bin.install "bin/build/docker-credential-pass"
  end

  test do
    if OS.mac?
      run_output = shell_output("#{bin}/docker-credential-osxkeychain", 1)
      assert_match "Usage: docker-credential-osxkeychain", run_output
    else
      run_output = shell_output("#{bin}/docker-credential-secretservice list", 1)
      assert_match "Cannot autolaunch D-Bus without X11", run_output
    end
    run_output = shell_output("#{bin}/docker-credential-pass list")
    assert_match "{}", run_output
  end
end