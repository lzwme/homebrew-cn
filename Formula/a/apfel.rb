class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://ghfast.top/https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "0069cb125eee5faeef6810fe2d4b8bb95ba23a68a64c3e8ee5105fc94f69209b"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  bottle do
    sha256 arm64_tahoe: "7faec181661af5cbf0d94051943915747cc5aa976898aebb001948a1e3f86fa0"
  end

  depends_on xcode: ["26.4", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/apfel"
  end

  service do
    run [opt_bin/"apfel", "--serve"]
    keep_alive true
    working_dir var
    log_path var/"log/apfel.log"
    error_log_path var/"log/apfel.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apfel --version")
    shell_output("#{bin}/apfel --no-color --model-info")
  end
end