class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://ghfast.top/https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "23849397e41983317ab9f8dd38e8b0a52d9ec4d9f71d4a2857e93dfbfbccb20e"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae17988a0f266b18dce6508c728292b7ca3e9705bf3bcdf7798089643a854264"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9777330925574c23208c815e8808475c8a5d51a0559e58ec22c2854a39790df"
  end

  depends_on xcode: ["26.4", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    system "swift", "build", *std_swift_args
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