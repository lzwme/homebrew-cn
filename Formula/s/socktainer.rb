class Socktainer < Formula
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://socktainer.github.io"
  url "https://ghfast.top/https://github.com/socktainer/socktainer/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "6cc0c5c6356d72075f3bd4f9e116e52937d1dd8822ad623e2d0df97f4601e59e"
  license "Apache-2.0"
  head "https://github.com/socktainer/socktainer.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77845a73914bc149ffcafe7924bb153c1b70fac208e33471ad2137ff22bbcf2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9be2dfe30df9d468811dfdd5f96043a100ad2a51d0ef6eaf3aa3aea2f44500a"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on "container"
  depends_on macos: :tahoe

  uses_from_macos "swift" => :build

  def install
    with_env(BUILD_VERSION: version.to_s) do
      system "swift", "build", *std_swift_args
    end
    bin.install ".build/release/socktainer"
    (var/"run/socktainer").mkpath
  end

  def caveats
    <<~EOS
      Socktainer exposes a Docker-compatible REST API. You can connect any tools you installed for Docker daemon.

      To connect it to your tools, add the following to ~/.bash_profile or ~/.zshrc:
        export DOCKER_HOST=unix://#{var}/run/socktainer/.socktainer/container.sock
    EOS
  end

  service do
    run [opt_bin/"socktainer"]
    keep_alive true
    environment_variables HOME: var/"run/socktainer", PATH: std_service_path_env
    log_path var/"log/socktainer.log"
    error_log_path var/"log/socktainer-error.log"
  end

  test do
    # Apple container cannot be run in a test environment, so we use version check.
    assert_match version.to_s, shell_output("#{bin}/socktainer --version")
  end
end