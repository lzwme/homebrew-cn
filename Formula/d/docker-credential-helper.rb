class DockerCredentialHelper < Formula
  desc "Platform keystore credential helper for Docker"
  homepage "https://github.com/docker/docker-credential-helpers"
  url "https://ghfast.top/https://github.com/docker/docker-credential-helpers/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "6cb45cdd1e7f964fb15bc260f55238d90eb365d1d3d4cb7f41418637a9316a6d"
  license "MIT"
  head "https://github.com/docker/docker-credential-helpers.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4614b00d81a1c68c68600bef64c4f8d81a7c686bbeac3740c39a0a0fb4bac6c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3ddc91f467c56c380e7451f75b858ef84fd920415461ca81aa3fcd7ca29a78c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0f64396575b904f164e27b104d0e1cb5c71655dc80858016e9ea7d5533742e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9114a80fe4cf2a5b41269f03e9b5ebb52a205b14284e98734d11ccc6a537bdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4891ab7c2706fdfdd7d2760e1684379fcf81ca5b0049cc3141bdf31fc4971270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22aa2d14d8dfdbc7796d54a8c86803493f8a1127cd78ff44ddd0154a11594178"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

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