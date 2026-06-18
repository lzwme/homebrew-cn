class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghfast.top/https://github.com/getgauge/gauge/archive/refs/tags/v1.6.32.tar.gz"
  sha256 "d0e875e5a044f27d0898bfa1e27ef7f6199fbac398c55aff856ec9b7c7b37d4b"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16238349218a83a7e054816983ea9d04098554e96b1d65882688547adb2381c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a09c394b394fe36a90809e73d74134961f66b50f7f0d26b9dc495dd7ae9da1cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc527c9526524bc36cea04d11faabd74f7f494fe3898c032421a364251159434"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b51c59abf1aa5c68f87f8a9a150f5630aa1c9c495c42fa73b29363ae9eda020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc03c99c3b8cafd600da3601bfca86c11aec6a22de960a037878f1a2700e6fb"
    sha256 cellar: :any,                 x86_64_linux:  "f4cd404c13f118f2a68a010587e86183344c47f4cfe95fc895373e9e5029a0bb"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end